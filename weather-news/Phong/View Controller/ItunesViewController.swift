//
//  ItunesViewController.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 11/27/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa
import RxAlamofire
import SwifterSwift
import SDWebImage
import AVFoundation
import AVKit

class ItunesViewController: UIViewController {
    
    let searchBar = UISearchBar()
    let table = UITableView()
    
    let bag = DisposeBag()
    
    let viewModel = ItunesViewModel()
    let apiHandler = ItunesAPIHandler.init(ItunesModel.self)
    let downloadHandler = PreviewDownloadHandler()
    let avPlayer = AVPlayerViewController()

    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        bindUI()
    }
    
    func search(_ searchTerm: String) {
        print ("Search for \(searchTerm)")
        guard let url = URL.constructURL(searchTerm) else { return }
        apiHandler.requestData(with: url)
    }

}

extension ItunesViewController: ItunesCellProtocol {
    
    func buttonPressed(_ cell: ItunesCell, with track: ItunesTrack) {
        if track.downloaded {
            playPreviewFile(track.previewUrl?.lastPathComponent)
        } else {
            cell.downloadIndicator.startAnimating()
            let downloadObserver = BehaviorRelay<Bool>(value: false)
            downloadObserver.subscribe(onNext: { (downloaded) in
                if downloaded {
                    cell.update(downloaded)
                    track.downloaded = downloaded
                }
            }, onError: { (error) in
                print ("Download Observer for \(track.trackName) error: \(error.localizedDescription)")
            }, onCompleted: {
                print ("Download Observer for \(track.trackName) completed")
            }).disposed(by: bag)
            downloadHandler.download(for: cell, with: track, observable: downloadObserver)
        }
    }
    
    private func playPreviewFile(_ fileName: String?) {
        guard let file = fileName,
            let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first
            else { print("Cannot get preview file"); return }
        let url = docURL.appendingPathComponent("\(file)")
        
        if !avPlayer.isBeingPresented {
            avPlayer.player?.pause()
            present(avPlayer, animated: true, completion: nil)
            let player = AVPlayer(url: url)
            player.rate = 1.0
            avPlayer.player = player
            player.play()
        }
    }
    
}

// MARK: - Set up UI
extension ItunesViewController {
    
    func bindUI() {
        
        searchBar.rx.searchButtonClicked.subscribe(onNext: { [weak self] (_) in
            guard let strongSelf = self else { return }
            if strongSelf.searchBar.isFirstResponder { strongSelf.searchBar.resignFirstResponder() }
            let searchTerm = strongSelf.searchBar.text ?? ""
            strongSelf.search(searchTerm)
            ActivityIndicatorHelper.showIndicator(with: .circleStrokeSpin)
        }).disposed(by: bag)
        
        apiHandler.observable?.subscribe(onNext: { [weak self] (itunesModel) in
            guard let model = itunesModel else { print("apiHandler obserable is nil"); return }
            self?.viewModel.updateModel(model)
        }, onError: { (error) in
            print ("apiHandler observable error \(error.localizedDescription)")
        }, onCompleted: {
            print ("apiHandler observable completed")
        }).disposed(by: bag)
        
        viewModel.observable.bind(to: table.rx.items(cellIdentifier: "cell", cellType: ItunesCell.self)) { [weak self] row, element, cell in
            cell.configure()
            cell.delegate = self
            cell.track = element
        }.disposed(by: bag)
        
    }
    
    func setup() {
        
        view.addSubviews([searchBar, table])
        view.backgroundColor = .white
        setupSearchBar()
        setupTableView()
    }
    
    func setupSearchBar() {
        
        // View
        searchBar.threeSidesConstraintWithHeight(yAnchor: searchBar.topAnchor, yConstant: 0, toYAnchor: view.safeAreaLayoutGuide.topAnchor, leftAnchor: view.leftAnchor, leftConstant: 0, rightAnchor: view.rightAnchor, rightConstant: 0, heightConstant: 60)
        searchBar.showsCancelButton = true
        searchBar.autocapitalizationType = .none
        searchBar.backgroundImage = nil
        searchBar.placeholder = "Search for songs..."
        
        // Rx
        searchBar.rx.cancelButtonClicked.subscribe { [weak self] (_) in
            guard let strongSelf = self else { return }
            if strongSelf.searchBar.isFirstResponder {
                strongSelf.searchBar.text = nil
                strongSelf.searchBar.resignFirstResponder()
            }
        }.disposed(by: bag)
        
    }
    
    func setupTableView() {
        
        // View
        table.register(ItunesCell.self, forCellReuseIdentifier: "cell")
        table.fourSidesConstraint(topAnchor: searchBar.bottomAnchor, topConstant: 0, bottomAnchor: view.bottomAnchor, bottomConstant: 0, leftAnchor: view.leftAnchor, leftConstant: 0, rightAnchor: view.rightAnchor, rightConstant: 0)
        table.rowHeight = 70
        
        // Rx
        table.rx.itemSelected.subscribe(onNext: { [weak self] (indexPath) in
            guard let strongSelf = self else { return }
            if strongSelf.searchBar.isFirstResponder { strongSelf.searchBar.resignFirstResponder() }
            ActivityIndicatorHelper.showIndicator(with: .ballPulse)
            let selectedCell = strongSelf.table.cellForRow(at: indexPath)
            let itunesTrackVC = ItunesTrackViewController()
            itunesTrackVC.modalPresentationStyle = .overCurrentContext
            itunesTrackVC.track = self?.viewModel.getTrackAtIndex(indexPath.row)
            strongSelf.present(itunesTrackVC, animated: true, completion: {
                ActivityIndicatorHelper.hideIndicator()
                selectedCell?.isSelected = false
            })
        }, onError: { (error) in
            print ("Table View item selected subscribe error: \(error.localizedDescription)")
        }, onCompleted: {
            print ("Table View item selected subscribe completed")
        }).disposed(by: bag)
        
    }
    
}
