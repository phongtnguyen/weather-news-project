//
//  ItunesViewModel.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 11/27/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ItunesViewModel {
    
    private var tracks: [ItunesTrack] = []
    
    var observable = PublishRelay<[ItunesTrack]>()
    
    func updateModel (_ itunesModel: ItunesModel) {
        
        var index = 0
        tracks = itunesModel.results.compactMap({ (track) -> ItunesTrack in
            let itunesTrack = ItunesTrack(artistName: track.artistName, trackName: track.trackName, previewUrl: track.previewUrl, index: index, collection: track.collectionName, artistURL: track.artistViewUrl, collectionURL: track.collectionViewUrl, trackURL: track.trackViewUrl, artworkURL60: track.artworkUrl60, artworkURL100: track.artworkUrl100, collectionPrice: track.collectionPrice, trackPrice: track.trackPrice, releaseDate: track.releaseDate, genre: track.primaryGenreName, country: track.country, trackTimeMillis: track.trackTimeMillis)
            index += 1
            return itunesTrack
        })
        observable.accept(tracks)
    }
    
    func getTrackAtIndex(_ index: Int) -> ItunesTrack? {
        guard index < tracks.count else { return nil }
        return tracks[index]
    }
    
}

class ItunesTrack {
    var index: Int
    var artistName: String
    var trackName: String
    var previewUrl: URL?
    var collectionName: String
    var artistViewUrl: URL?
    var collectionViewUrl: URL?
    var trackViewUrl: URL?
    var artworkUrl60: URL?
    var artworkUrl100: URL?
    var collectionPrice: Float
    var trackPrice: Float
    var releaseDate: String
    var primaryGenreName: String
    var country: String
    var trackTimeMillis: Int
    
    var downloaded = false
    
    init(artistName: String, trackName: String, previewUrl: String, index: Int, collection: String, artistURL: String, collectionURL: String, trackURL: String, artworkURL60: String, artworkURL100: String, collectionPrice: Float, trackPrice: Float, releaseDate: String, genre: String, country: String, trackTimeMillis: Int) {
        self.artistName = artistName
        self.trackName = trackName
        self.previewUrl = URL(string: previewUrl)
        self.index = index
        self.collectionName = collection
        self.artistViewUrl = URL(string: artistURL)
        self.collectionViewUrl = URL(string: collectionURL)
        self.trackViewUrl = URL(string: trackURL)
        self.artworkUrl60 = URL(string: artworkURL60)
        self.artworkUrl100 = URL(string: artworkURL100)
        self.collectionPrice = collectionPrice
        self.trackPrice = trackPrice
        self.releaseDate = DateFormatter.formatDateFromString(releaseDate)
        self.primaryGenreName = genre
        self.country = country
        self.trackTimeMillis = trackTimeMillis
    }
}

