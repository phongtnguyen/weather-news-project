//
//  PreviewDownloadHandler.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/1/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import RxAlamofire
import Alamofire
import RxSwift
import RxCocoa

class PreviewDownloadHandler {
    
    let bag = DisposeBag()
    
    func download(for cell: ItunesCell, with track: ItunesTrack, observable: BehaviorRelay<Bool>) {
        guard let url = track.previewUrl else { print ("No preview url for \(track.trackName)"); return }
        
        let destination: DownloadRequest.DownloadFileDestination = getFilePath(url.lastPathComponent)
        // http://www.programmersought.com/article/2396801293/
        RxAlamofire.download(URLRequest(url: url), to: destination).subscribe(onNext: { (element) in
            element.downloadProgress { (progress) in
                // update progress
            }
        }, onError: { (error) in
            print ("PreviewDownloadHandler download error \(error.localizedDescription)")
        }, onCompleted: {
            print ("PreviewDownloadHandler download completed for \(track.trackName)")
            observable.accept(true)
        }).disposed(by: bag)
    }
    
    // MARK: Download directory and options
    private func getFilePath(_ fileName: String) -> DownloadRequest.DownloadFileDestination {
        let destination: DownloadRequest.DownloadFileDestination = { (destionation, option) in
            let docURL = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
            let fileURL = docURL.appendingPathComponent(fileName)
            print ("Download location for \(fileName) is \(fileURL)")
            return (fileURL, [.removePreviousFile, .createIntermediateDirectories])
        }
        return destination
    }
    
}
