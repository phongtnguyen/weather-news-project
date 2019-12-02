//
//  ItunesCell.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 11/29/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import UIKit
import SDWebImage
import RxSwift
import RxCocoa
import NVActivityIndicatorView

protocol ItunesCellProtocol: NSObject {
    func buttonPressed(_ cell: ItunesCell, with track: ItunesTrack)
}

class ItunesCell: UITableViewCell {
    
    // MARK: - View Components
    let artworkImage = UIImageView()
    let titleLabel = UILabel()
    let artistLabel = UILabel()
    let albumLabel = UILabel()
    let priceLabel = UILabel()
    let progressLabel = UILabel()
    let downloadButton = UIButton()
    let downloadIndicator = NVActivityIndicatorView(frame: CGRect(x: 0, y: 0, width: 25, height: 25), type: .pacman, color: .lightGray)
    
//    var downloaded = false
    let bag = DisposeBag()
    weak var delegate: ItunesCellProtocol?
    
    // MARK: - Track for cell
    var track: ItunesTrack? {
        didSet {
            if let track = track {
                titleLabel.text = track.trackName
                artistLabel.text = track.artistName
                albumLabel.text = track.collectionName
                priceLabel.text = String(format: "%.2f", track.trackPrice)
                if let url: URL = track.artworkUrl60 {
                    artworkImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                        if let error = error { print (error.localizedDescription) }
                    }
                } else if let url: URL = track.artworkUrl100 {
                    artworkImage.sd_setImage(with: url) { (image, error, cacheType, url) in
                        if let error = error { print (error.localizedDescription) }
                    }
                }
//                downloaded = track.downloaded
                if let image = UIImage(named: "\(track.downloaded ? "play" : "download")_cloud") {
                    downloadButton.configure(image: image, tintColor: .black, contentMode: .scaleToFill, tag: 2000)
                } else {
                    downloadButton.setTitle(track.downloaded ? "Play" : "Download", for: .normal)
                }
                bindUI(track)
            }
        }
    }
    
    func update(_ isDownloaded: Bool) {
        if let image = UIImage(named: "\(isDownloaded ? "play" : "download")_cloud") {
            downloadButton.configure(image: image, tintColor: .black, contentMode: .scaleToFill, tag: 2000)
        } else {
            downloadButton.setTitle(isDownloaded ? "Play" : "Download", for: .normal)
        }
        if isDownloaded && downloadIndicator.isAnimating {
            downloadIndicator.stopAnimating()
        }
    }
    
    // MARK: - Configure dynamic view components
//    func config(download: Download?) {
//        if downloaded {
//            downloadButton.setTitleForAllStates("Play")
//        } else {
//            downloadButton.setTitleForAllStates("Download")
//        }
//
//        var hideDownloadControl = true
//
//        if download != nil {
//            hideDownloadControl = false
//        }
//
//        progressLabel.isHidden = hideDownloadControl
//
////        print ("config for cell at \(self.track?.trackName) with progressLabel hidden \(!downloaded) and downloaded \(downloaded)")
//    }
    
    // MARK: - Set up initial cell content view
    func configure() {
        contentView.addSubviews([titleLabel, artistLabel, downloadButton, progressLabel, artworkImage, downloadIndicator])
        
        titleLabel.configure(font: .monospacedDigitSystemFont(ofSize: 18, weight: .medium), textColor: .black, alignment: .left)
        artistLabel.configure(font: .italicSystemFont(ofSize: 14), textColor: .darkGray, alignment: .left)
        albumLabel.configure(font: .systemFont(ofSize: 14, weight: .light), textColor: .gray, alignment: .right)
//        albumLabel.configure(font: .monospacedSystemFont(ofSize: 14, weight: .light), textColor: .gray, alignment: .right)
        priceLabel.configure(font: .systemFont(ofSize: 14, weight: .regular), textColor: .gray, alignment: .right)
        progressLabel.configure(font: .monospacedDigitSystemFont(ofSize: 12, weight: .regular), textColor: .darkGray, alignment: .right)
        artworkImage.configure(contentMode: .scaleAspectFill, borderWidth: 0, borderColor: nil)
        
        artworkImage.addConstraintsWithWidthEqualHeight(yAnchor: artworkImage.topAnchor, by: 5, to: contentView.topAnchor, xAnchor: artworkImage.leadingAnchor, by: 5, to: contentView.leadingAnchor, size: 60)
        
        titleLabel.addConstraintsWithKnownHeight(top: contentView.topAnchor, topConstant: 5, trailing: contentView.trailingAnchor, trailingConstant: 5, leading: artworkImage.trailingAnchor, leadingConstant: 10)
        
        artistLabel.addConstraintsWithKnownSize(yAnchor: artistLabel.topAnchor, by: 0, to: titleLabel.bottomAnchor, xAnchor: artistLabel.leadingAnchor, by: 10, to: artworkImage.trailingAnchor)
        
        downloadButton.configure(title: "Download", titleColor: .blue, tag: 2000, font: .systemFont(ofSize: 14, weight: .light), background: .white)
        downloadButton.addConstraintsWithSize(yAnchor: downloadButton.topAnchor, by: 0, to: titleLabel.bottomAnchor, xAnchor: downloadButton.trailingAnchor, by: -5, to: contentView.trailingAnchor, height: 45, width: 45)
        
        progressLabel.addConstraintsWithKnownSize(yAnchor: progressLabel.topAnchor, by: 0, to: downloadButton.bottomAnchor, xAnchor: progressLabel.trailingAnchor, by: -5, to: contentView.trailingAnchor)
        progressLabel.isHidden = true
        
        downloadIndicator.addConstraintsWithKnownSize(yAnchor: downloadIndicator.topAnchor, by: 0, to: artistLabel.bottomAnchor, xAnchor: downloadIndicator.leadingAnchor, by: 10, to: artworkImage.trailingAnchor)
    }
    
    private func bindUI(_ track: ItunesTrack) {
        downloadButton.rx.tap.subscribe(onNext: { [weak self] () in
            guard let strongSelf = self, let track = strongSelf.track else { return }
            strongSelf.delegate?.buttonPressed(strongSelf, with: track)
//            strongSelf.downloadIndicator.startAnimating()
        }, onError: { (error) in
            print ("Cell Download button error: \(error.localizedDescription) for \(track.trackName)")
        }, onCompleted: {
            print ("Cell Download button completed for \(track.trackName)")
        }).disposed(by: bag)
    }
    
}
