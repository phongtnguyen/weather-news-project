//
//  ItunesTrackViewController.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 11/29/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//
// icon pack: https://icons8.com/icon/pack/media-controls/clouds

import UIKit
import AVFoundation
import Alamofire
import RxSwift
import RxCocoa
import RxAlamofire
import MarqueeLabel
import MediaPlayer
import RxDataSources

class ItunesTrackViewController: UIViewController {
    
    // MARK: - View components
    let artworkImage = UIImageView()
    let artistAlbumLabel = MarqueeLabel()
    let trackLabel = MarqueeLabel()
    let priceLabel = UILabel()
    let releaseDateLabel = UILabel()
    let genreLabel = UILabel()
    let countryLabel = UILabel()
    let buyButton = UIButton()
    let dismissButton = UIButton()
    let scrollView = UIScrollView()
    let table = UITableView()
    
    let playerView = UIView()
    let playerArtwork = UIImageView()
    let playerTitle = MarqueeLabel()
    let playerArtist = UILabel()
    let playerPlayButton = UIButton()
    let playerNextButton = UIButton()
    let playerNotPlaying = UILabel.init(text: "Not Playing")
    let playbackProgress = UIProgressView()
    
    var isPlaying = BehaviorRelay<Bool>(value: false)
    
    let musicPlayer = MusicPlayerController.shared
    
    var track: ItunesTrack? {
        didSet {
            if let _ = track {
                updateTrackInfo()
            }
        }
    }
    let viewModel = MediaViewModel()
    var sectionModel = BehaviorRelay<[SectionModel]>(value: [])
    
    let bag = DisposeBag()
    
    private func updateTrackInfo() {
        guard let track = track else { return }
        trackLabel.text = "\(track.trackName)"
        artistAlbumLabel.text = "\(track.artistName) –– \(track.collectionName)"
        releaseDateLabel.text = "Release: \(track.releaseDate)"
        priceLabel.text = "Single: $\(track.trackPrice) –– Album: $\(track.collectionPrice)"
        genreLabel.text = "Genre: \(track.primaryGenreName)"
        countryLabel.text = "Country: \(track.country)"
        
        let buttonAttributedTitle = NSMutableAttributedString(string: "Buy song ", attributes: [.font: UIFont.systemFont(ofSize: 13)])
        let price = NSMutableAttributedString(string: "$\(track.trackPrice)", attributes: [.font: UIFont.boldSystemFont(ofSize: 13)])
        buttonAttributedTitle.append(price)
        buyButton.setAttributedTitle(buttonAttributedTitle, for: .normal)
        
        usePreviewArtwork(track)
        
        getHighQualityArtwork(track.trackViewUrl)
        
        getMediaFromLibrary(track)
    }
    
    private func usePreviewArtwork(_ track: ItunesTrack) {
        if let url = track.artworkUrl100 {
            artworkImage.sd_setImage(with: url, completed: nil)
        } else if let url = track.artworkUrl60 {
            artworkImage.sd_setImage(with: url, completed: nil)
        } else {
            artworkImage.sd_setImage(with: URL(string: "https://user-images.githubusercontent.com/24848110/33519396-7e56363c-d79d-11e7-969b-09782f5ccbab.png"), completed: nil)
        }
    }
    
    private func getHighQualityArtwork(_ trackURL: URL?) {
        
        guard let url = trackURL else { return }
        ItunesURLHandler().requestData(with: url).subscribe(onNext: { [weak self] (data) in
            DispatchQueue.global(qos: .background).async { //parse html takes long time
                if let url = ItunesHTMLParser.parseHTMLFromDataForURL(data) {
                    print ("Update High Quality Artwork with url: \(url.absoluteString)")
                    self?.artworkImage.sd_setImage(with: url, completed: nil) // No need to specify on GCD Main?
                }
            }
        }, onError: { (error) in
            print ("ItunesURLHandler requestData subscribe error: \(error.localizedDescription)")
        }, onCompleted: {
            print ("ItunesURLHandler requestData subscribe completed")
        }).disposed(by: bag)
        
    }
    
    private func getMediaFromLibrary(_ track: ItunesTrack) {
        let mediaLibraryHandler = MediaLibraryHandler()
        let (songsByTitle, songsByArtist, relatedSongs) = mediaLibraryHandler.getMediaWithTrackInfo(track)
        
        viewModel.updateModel(songsByTitle, songsByArtist, relatedSongs)
    }
    
    private func updatePlayerButton(_ isPlaying: Bool) {
        let state = isPlaying ? "pause" : "play"
        print ("Playing state \(state)")
        
        if let image = UIImage(named: "\(state)_cloud") {
            playerPlayButton.setImage(image: image, tintColor: .black, contentMode: .scaleToFill)
        } else {
            playerPlayButton.setTitle(title: state.capitalized, titleColor: .black, font: .systemFont(ofSize: 20, weight: .bold))
        }
        
        if let image = UIImage(named: "next_cloud") {
            playerNextButton.setImage(image: image, tintColor: .black, contentMode: .scaleToFill)
        } else {
            playerNextButton.setTitle(title: "Next", titleColor: .black, font: .systemFont(ofSize: 20, weight: .bold))
        }
    }
    
    private func setSelectedSong(_ indexPath: IndexPath) {
        let section = sectionModel.value[indexPath.section]
        musicPlayer.queueSongs(with: section.items, start: indexPath.row)
        isPlaying.accept(false)
        updatePlayerView(with: musicPlayer.playbackQueue.first)
    }
    
    private func setPlayingSong(_ mediaItem: MPMediaItem) {
        playerNotPlaying.isHidden = true
        playerTitle.text = mediaItem.title ?? "NO TITLE INFO"
        playerArtist.text = mediaItem.artist ?? "NO ARTIST INFO"
        playerArtwork.image = mediaItem.artwork?.image(at: CGSize(width: 40, height: 40))
        playerPlayButton.isUserInteractionEnabled = true
        playerNextButton.isUserInteractionEnabled = true
        playbackProgress.isHidden = false
    }
    
    private func setNoPlayingSong() {
        playerNotPlaying.isHidden = false
        playerTitle.text = ""
        playerArtist.text = ""
        playerArtwork.image = UIImage(named: "music")
        playerPlayButton.isUserInteractionEnabled = false
        playerNextButton.isUserInteractionEnabled = false
        playbackProgress.isHidden = true
    }
    
    private func updatePlayerView(with mediaItem: MPMediaItem?) {
        if let playingItem = mediaItem {
            setPlayingSong(playingItem)
        } else {
            setNoPlayingSong()
        }
    }
    
    private func shouldPlayMusic() {
        var isPlaying = self.isPlaying.value
        if isPlaying {
            musicPlayer.pause()
        } else {
            musicPlayer.play()
        }
        isPlaying.toggle()
        self.isPlaying.accept(isPlaying)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindUI()
        // https://stackoverflow.com/questions/30659158/how-to-update-mpmusicplayercontroller-when-song-changes
        NotificationCenter.default.addObserver(self, selector: #selector(currentPlayingItemDidChange), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
    }
    
    @objc func currentPlayingItemDidChange() {
        updatePlayerView(with: musicPlayer.nowPlayingItem())
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }

}

extension ItunesTrackViewController {
    
    private func bindUI() {
        
        dismissButton.rx.tap.subscribe(onNext: { [weak self] () in
            self?.dismiss(animated: true, completion: nil)
        }, onError: { (error) in
            print ("Dismiss button tap subscribe error \(error.localizedDescription)")
        }, onCompleted: {
            print ("Dismiss button tap subscribe completed")
        }).disposed(by: bag)
        
        buyButton.rx.tap.subscribe(onNext: { [weak self] () in
            guard let strongSelf = self, let url = strongSelf.track?.trackViewUrl else { print("Failed to get track url"); return }
            UIApplication.shared.open(url)
        }, onError: { (error) in
            print ("Buy button tap subscribe error \(error.localizedDescription)")
        }, onCompleted: {
            print ("Buy button tap subscribe completed")
        }).disposed(by: bag)
        
        // MARK: Table view rx
        table.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            self?.setSelectedSong(indexPath)
        }, onError: { (error) in
            print ("Table item selected subscribe error: \(error.localizedDescription)")
        }, onCompleted: {
            print ("Table item selected subscribe completed")
        }).disposed(by: bag)
        
        table.rx.didScroll.observeOn(MainScheduler.asyncInstance).subscribe(onNext: { [weak self] () in
            guard let strongSelf = self else { return }
            strongSelf.table.isScrollEnabled = strongSelf.table.contentOffset.y > 0
        }, onError: { (error) in
            print ("table didScrollToTop error: \(error.localizedDescription)")
        }, onCompleted: {
            print ("table didScrollToTop completed")
        }).disposed(by: bag)
        
        // MARK: - Table datasource and delegate rx
        // https://stackoverflow.com/questions/55378613/rxdatasources-tableview-with-multiple-sections-from-one-api-source
        // http://rx-marin.com/post/bind-multiple-cells/
        Observable.combineLatest(viewModel.observableByTitle, viewModel.observableByArtist, viewModel.observableRelated).subscribe(onNext: { [weak self] (songsByTitle, songsByArtist, songsRelated) in
            self?.shouldDisplayMediaItems(fromTitle: songsByTitle, fromArtist: songsByArtist, fromRelated: songsRelated)
        }, onError: { (error) in
            print ("Observable by artist and title error: \(error.localizedDescription)")
        }, onCompleted: {
            print ("Observable by artist and title completed")
        }).disposed(by: bag)
        
        let dataSource = RxTableViewSectionedReloadDataSource<SectionModel>(configureCell: { (dataSource, table, indexPath, mediaItem) in
            let cell = table.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MediaCell
            cell.backgroundColor = .clear
            cell.configure()
            cell.song = mediaItem
            return cell
        })
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            return dataSource.sectionModels[index].sectionTitle
        }
        
        sectionModel.bind(to: table.rx.items(dataSource: dataSource)).disposed(by: bag)
    }
    
    private func shouldDisplayMediaItems(fromTitle: [MPMediaItem], fromArtist: [MPMediaItem], fromRelated: [MPMediaItem]) {
        let titleSection = SectionModel.Title(items: fromTitle)
        let artistSection = SectionModel.Artist(items: fromArtist)
        let relatedSection = SectionModel.Related(items: fromRelated)
        
        let displaySections = [titleSection, artistSection, relatedSection].filter({ $0.items.count > 0 })
        sectionModel.accept(displaySections)
    }
    
    
    // MARK: - Player View
    private func setupPlayerView() {
        playerView.setBlurBackground(.light)
        playerView.layer.borderColor = UIColor.gray.cgColor
        playerView.layer.borderWidth = 1
        
        playerView.addSubviews([playerTitle, playerArtwork, playerArtist, playerPlayButton, playerNotPlaying, playbackProgress, playerNextButton])
        
        playerView.threeSidesConstraintWithHeight(yAnchor: playerView.bottomAnchor, yConstant: 0, toYAnchor: view.bottomAnchor, leftAnchor: view.leftAnchor, leftConstant: -1, rightAnchor: view.rightAnchor, rightConstant: 1, heightConstant: 57)
        
        playerNextButton.addConstraintsWithWidthEqualHeight(yAnchor: playerNextButton.centerYAnchor, by: 0, to: playerView.centerYAnchor, xAnchor: playerNextButton.trailingAnchor, by: -11, to: playerView.trailingAnchor, size: 40)
        playerPlayButton.addConstraintsWithWidthEqualHeight(yAnchor: playerPlayButton.centerYAnchor, by: 0, to: playerView.centerYAnchor, xAnchor: playerPlayButton.trailingAnchor, by: -5, to: playerNextButton.leadingAnchor, size: 40)
        
        playerArtwork.configure(contentMode: .scaleAspectFill, borderWidth: 0, borderColor: UIColor.black.cgColor)
        playerArtwork.layer.cornerRadius = 5
        playerArtwork.addConstraintsWithWidthEqualHeight(yAnchor: playerArtwork.topAnchor, by: 5, to: playerView.topAnchor, xAnchor: playerArtwork.leadingAnchor, by: 16, to: playerView.leadingAnchor, size: 40)
        
        playerTitle.speed = MarqueeLabel.SpeedLimit.rate(10)
        playerTitle.trailingBuffer = 50
        playerTitle.configure(font: .systemFont(ofSize: 17, weight: .regular), textColor: .black, alignment: .left)
        playerTitle.threeSidesConstraintWithHeight(yAnchor: playerTitle.topAnchor, yConstant: 5, toYAnchor: playerView.topAnchor, leftAnchor: playerArtwork.rightAnchor, leftConstant: 10, rightAnchor: playerPlayButton.leftAnchor, rightConstant: -5, heightConstant: 22)
        
        playerArtist.configure(font: .systemFont(ofSize: 14, weight: .light), textColor: .gray, alignment: .left)
        playerArtist.threeSidesConstraintWithHeight(yAnchor: playerArtist.topAnchor, yConstant: 0, toYAnchor: playerTitle.bottomAnchor, leftAnchor: playerArtwork.rightAnchor, leftConstant: 10, rightAnchor: playerPlayButton.leftAnchor, rightConstant: -5, heightConstant: 18)
        
        playerNotPlaying.configure(font: .systemFont(ofSize: 18, weight: .regular), textColor: .black, alignment: .left)
        playerNotPlaying.threeSidesConstraintWithHeight(yAnchor: playerNotPlaying.centerYAnchor, yConstant: 0, toYAnchor: playerView.centerYAnchor, leftAnchor: playerArtwork.rightAnchor, leftConstant: 10, rightAnchor: playerPlayButton.leftAnchor, rightConstant: -5, heightConstant: 25)
        
        playbackProgress.addToViewWithConstraints(top: playerArtwork.bottomAnchor, topConstant: 5, bottom: playerView.bottomAnchor, bottomConstant: -4, leading: playerView.leadingAnchor, leadingConstant: 16, trailing: playerView.trailingAnchor, trailingConstant: -6)
        playbackProgress.isHidden = true
        playbackProgress.progressTintColor = .darkGray
        
        playerPlayButton.rx.tap.subscribe(onNext: { [weak self] () in
            self?.shouldPlayMusic()
        }, onError: { (error) in
            print ("player play button tap subscribe error: \(error.localizedDescription)")
        }, onCompleted: {
            print ("player play button tap subscribe completed")
        }).disposed(by: bag)
        
        playerNextButton.rx.tap.subscribe(onNext: { [weak self] () in
            self?.musicPlayer.next()
        }, onError: { (error) in
            print ("player next button tap subscribe error: \(error.localizedDescription)")
        }, onCompleted: {
            print ("player next button tap subscribe completed")
        }).disposed(by: bag)
        
        isPlaying.subscribe(onNext: { [weak self] (playing) in
            self?.updatePlayerButton(playing)
        }, onError: { (error) in
            print ("isPlaying subscribe error: \(error.localizedDescription)")
        }, onCompleted: {
            print ("isPlaying subscribe completed")
        }).disposed(by: bag)
        
        musicPlayer.observablePlaybackProgress.subscribe(onNext: { [weak self] (playbackProgress) in
            self?.playbackProgress.setProgress(playbackProgress, animated: true)
        }, onError: { (error) in
            print ("musicPlayer playbackProgress error: \(error.localizedDescription)")
        }, onCompleted: {
            print ("musicPlayer playbackProgress completed")
        }).disposed(by: bag)
        
        if let playingItem = musicPlayer.nowPlayingItem() {
            isPlaying.accept(musicPlayer.isPlaying())
            updatePlayerView(with: playingItem)
        } else {
            updatePlayerView(with: nil)
        }
    }
    
    // MARK: - Main UI
    private func setup() {
        view.setBlurBackground(.extraLight)
        
        // MARK: Scroll view delegate => only allow table scroll when scroll view scrolls all the way
        scrollView.delegate = self
        scrollView.bounces = false
        
        // text size
        let headerTextSize: CGFloat = 18
        let bodyTextSize: CGFloat = 13
        let labelScrollRate = MarqueeLabel.SpeedLimit.rate(30)
        
        // stack view
        let stackView = UIStackView(arrangedSubviews: [priceLabel, releaseDateLabel, genreLabel, countryLabel], axis: .vertical, spacing: 0, alignment: .fill, distribution: .fillEqually)
        
        // scroll content view
        let contentView = UIView()
        
        // add to view
        view.addSubviews([scrollView, playerView])
        scrollView.addSubview(contentView)
        contentView.addSubviews([dismissButton, buyButton, artworkImage, artistAlbumLabel, trackLabel, stackView, table])
        
        // MARK: Buttons
        // Dismiss button
        if let image = UIImage(named: "dismiss") {
            dismissButton.configure(image: image, tintColor: .gray, contentMode: .scaleToFill, tag: 2000)
        } else {
            dismissButton.configure(title: "Close", titleColor: .gray, tag: 2000, font: .systemFont(ofSize: 12, weight: .semibold), background: nil)
        }
        
        // Buy button
        buyButton.configure(title: "Buy song", titleColor: .black, tag: 2200, font: .systemFont(ofSize: bodyTextSize), background: #colorLiteral(red: 1, green: 0.8019956946, blue: 0.2552993596, alpha: 1))
        buyButton.layer.cornerRadius = 5
        buyButton.layer.borderWidth = 1
        buyButton.layer.borderColor = UIColor.black.cgColor
        
        // MARK: Artwork Image
        artworkImage.addConstraintsWithSize(yAnchor: artworkImage.topAnchor, by: 20, to: dismissButton.bottomAnchor, xAnchor: artworkImage.centerXAnchor, by: 0, to: view.centerXAnchor, height: 250, width: 250)
        artworkImage.configure(contentMode: .scaleAspectFill, borderWidth: 0, borderColor: UIColor.black.cgColor)
        artworkImage.backgroundColor = nil
        
        // MARK: Labels
        trackLabel.speed = labelScrollRate
        trackLabel.trailingBuffer = 100
        trackLabel.configure(font: .systemFont(ofSize: headerTextSize, weight: .semibold), textColor: .black, alignment: .center)
        
        artistAlbumLabel.speed = labelScrollRate
        artistAlbumLabel.configure(font: .systemFont(ofSize: bodyTextSize, weight: .thin), textColor: .darkGray, alignment: .center)
        
        releaseDateLabel.configure(font: .systemFont(ofSize: bodyTextSize, weight: .light), textColor: .darkGray, alignment: .left)
        priceLabel.configure(font: .systemFont(ofSize: bodyTextSize, weight: .light), textColor: .darkGray, alignment: .left)
        genreLabel.configure(font: .systemFont(ofSize: bodyTextSize, weight: .light), textColor: .darkGray, alignment: .left)
        countryLabel.configure(font: .systemFont(ofSize: bodyTextSize, weight: .light), textColor: .darkGray, alignment: .left)
        
        // MARK: Table
        table.backgroundColor = .clear
        table.register(MediaCell.self, forCellReuseIdentifier: "cell")
        table.rowHeight = 50
        table.isScrollEnabled = false
        
        // MARK: Scroll view
        scrollView.showsVerticalScrollIndicator = false
        
        // MARK: Player view
        setupPlayerView()
        
        // MARK: Constraints
        scrollView.addToViewWithConstraints(top: view.safeAreaLayoutGuide.topAnchor, topConstant: 0, bottom: view.bottomAnchor, bottomConstant: 0, leading: view.leadingAnchor, leadingConstant: 0, trailing: view.trailingAnchor, trailingConstant: 0)
        
        contentView.addToViewWithConstraints(top: scrollView.topAnchor, topConstant: 0, bottom: scrollView.bottomAnchor, bottomConstant: 0, leading: scrollView.leadingAnchor, leadingConstant: 0, trailing: scrollView.trailingAnchor, trailingConstant: 0)
        
        contentView.widthAnchor.constraint(equalToConstant: view.frame.size.width).isActive = true
        contentView.heightAnchor.constraint(equalToConstant: view.frame.size.height*1.8).isActive = true
        
        // MARK: Scroll view first half constraints
        dismissButton.addConstraintsWithSize(yAnchor: dismissButton.topAnchor, by: 20, to: contentView.topAnchor, xAnchor: dismissButton.centerXAnchor, by: 0, to: contentView.centerXAnchor, height: 25, width: 40)
        buyButton.addConstraintsWithSize(yAnchor: buyButton.topAnchor, by: 10, to: artistAlbumLabel.bottomAnchor, xAnchor: buyButton.centerXAnchor, by: 0, to: contentView.centerXAnchor, height: 30, width: 130)
        trackLabel.threeSidesConstraintWithHeight(yAnchor: trackLabel.topAnchor, yConstant: 20, toYAnchor: artworkImage.bottomAnchor, leftAnchor: view.leftAnchor, leftConstant: 30, rightAnchor: contentView.rightAnchor, rightConstant: -30, heightConstant: 30)
        artistAlbumLabel.threeSidesConstraintWithHeight(yAnchor: artistAlbumLabel.topAnchor, yConstant: 0, toYAnchor: trackLabel.bottomAnchor, leftAnchor: view.leftAnchor, leftConstant: 10, rightAnchor: contentView.rightAnchor, rightConstant: -10, heightConstant: 25)
        stackView.addConstraintsWithSize(yAnchor: stackView.topAnchor, by: 30, to: buyButton.bottomAnchor, xAnchor: stackView.centerXAnchor, by: 0, to: contentView.centerXAnchor, height: 70, width: 300)
        
        // MARK: Scroll view second half constraints
        table.addToViewWithConstraints(top: stackView.bottomAnchor, topConstant: 20, bottom: contentView.bottomAnchor, bottomConstant: -60, leading: contentView.leadingAnchor, leadingConstant: 10, trailing: contentView.trailingAnchor, trailingConstant: -10)
    }
    
}

// https://stackoverflow.com/questions/33292427/how-to-make-the-scroll-of-a-tableview-inside-scrollview-behave-naturally
extension ItunesTrackViewController: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        print (view.frame.size.height, UIScreen.main.bounds.height)
        if scrollView == self.scrollView {
            table.isScrollEnabled = self.scrollView.contentOffset.y >= (view.frame.size.height*0.8 + 20)
        }
    }
}
