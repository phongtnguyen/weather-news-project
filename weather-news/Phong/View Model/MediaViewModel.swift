//
//  MediaViewModel.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 11/30/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import MediaPlayer
import RxSwift
import RxCocoa

class MediaViewModel {
    
    private var mediaByTitle: [MPMediaItem] = []
    private var mediaByArtist: [MPMediaItem] = []
    private var mediaRelated: [MPMediaItem] = []
    var observableByTitle = BehaviorRelay<[MPMediaItem]>(value: [])
    var observableByArtist = BehaviorRelay<[MPMediaItem]>(value: [])
    var observableRelated = BehaviorRelay<[MPMediaItem]>(value: [])
    
    func updateModel(_ mediaItemsByTitle: [MPMediaItem], _ mediaItemsByArtist: [MPMediaItem], _ mediaItemsRelated: [MPMediaItem]) {
        mediaByTitle = mediaItemsByTitle
        mediaByArtist = mediaItemsByArtist
        mediaRelated = mediaItemsRelated
        
        observableByTitle.accept(mediaByTitle)
        observableByArtist.accept(mediaByArtist)
        observableRelated.accept(mediaRelated)
    }
    
    func getMediaItemForTitle(at index: Int) -> MPMediaItem? {
        guard index < mediaByTitle.count else { return nil }
        return mediaByTitle[index]
    }
    
    func getMediaItemForArtist(at index: Int) -> MPMediaItem? {
        guard index < mediaByArtist.count else { return nil }
        return mediaByArtist[index]
    }
    
    func getMediaItemRelated(at index: Int) -> MPMediaItem? {
        guard index < mediaRelated.count else { return nil }
        return mediaRelated[index]
    }
}
