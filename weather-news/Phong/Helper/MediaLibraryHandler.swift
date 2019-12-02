//
//  MediaLibraryHandler.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 11/30/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import MediaPlayer

class MediaLibraryHandler {
    
    static var mediaItems = MPMediaQuery.songs().items
    
    let minMatchedByTitle = 1
    let minMatchedByArtist = 5
    let maxRelatedSongs = 20
    
    static func updateAllMediaItems() {
        mediaItems = MPMediaQuery.songs().items
    }
    
    func getMediaWithTrackInfo(_ track: ItunesTrack) -> (matchedTitle: [MPMediaItem], matchedArtist: [MPMediaItem], fuzzyMatched: [MPMediaItem]) {
        
        let matchedByTitle = getMediaWithExactMatchedTitle(track.trackName)
        
        let matchedByArtist = getMediaWithExactMatchedArtist(track.artistName).filter { (mediaItem) -> Bool in
            return !matchedByTitle.contains(mediaItem)
        }
        
        var matchedByRelated: [MPMediaItem] = []
        
        if matchedByTitle.count < minMatchedByTitle || matchedByArtist.count < minMatchedByArtist {
            matchedByRelated = getMediaThatMightBeRelated(track, except: matchedByTitle+matchedByArtist)
        }
        
        return (matchedByTitle, matchedByArtist, matchedByRelated)
    }
    
    private func getMediaThatMightBeRelated(_ track: ItunesTrack, except: [MPMediaItem]) -> [MPMediaItem] {
        guard let allMedia = MediaLibraryHandler.mediaItems else { return [] }
        
        print ("Related by \(track.primaryGenreName) and \(track.collectionName)")
        // check genre, collection
        let relatedByCollection = relatedByProperty(track.collectionName, .Collection, from: allMedia).filter({ !except.contains($0) })
//        for item in relatedByCollection {
//            print (item.title ?? "No title", item.albumTitle ?? "No album")
//        }
        
        let relatedByGenre = relatedByProperty(track.primaryGenreName, .Genre, from: allMedia).filter({ !except.contains($0) })
//        for item in relatedByGenre {
//            print (item.title ?? "No title", item.genre ?? "No genre")
//        }
        
        let relatedMedia: [MPMediaItem] = Array(Set(relatedByCollection+relatedByGenre))
        
        return relatedMedia.count > maxRelatedSongs ? Array(relatedMedia[0...19]) : relatedMedia
    }
    
    private func relatedByProperty(_ trackProperty: String, _ property: MediaProperty, from items: [MPMediaItem]) -> [MPMediaItem] {
        return items.filter { (mediaItem) -> Bool in
            switch property {
            case .Collection:
                guard let collection = mediaItem.albumTitle else { return false }
                return collection.lowercased() == trackProperty.lowercased()
            case .Genre:
                guard let genre = mediaItem.genre else { return false }
                return genre.lowercased() == trackProperty.lowercased()
            }
        }
    }
    
    private func getMediaWithExactMatchedTitle(_ title: String) -> [MPMediaItem] {
        guard let allMedia = MediaLibraryHandler.mediaItems else { return [] }
        return allMedia.filter({ $0.title != nil && $0.title! == title })
    }
    
    private func getMediaWithExactMatchedArtist(_ artist: String) -> [MPMediaItem] {
        guard let allMedia = MediaLibraryHandler.mediaItems else { return [] }
        return allMedia.filter({ $0.artist != nil && $0.artist! == artist })
    }
    
//    private func getMediaWithFuzzyMatchedTitle(_ title: String) -> [MPMediaItem] {
//        guard let allMedia = MediaLibraryHandler.mediaItems else { return [] }
//        let fuzzyMatchedMedia = allMedia.filter { (item) -> Bool in
//            guard let itemTitle = item.title else { return false }
//            return itemTitle.fuzzyMatchPattern(title) != nil || title.fuzzyMatchPattern(itemTitle) != nil
////            let confidence = getConfidenceScore(confidenceOfItem: itemTitle.confidenceScore(title), confidenceOfTrack: title.confidenceScore(itemTitle))
////            return confidence < maxConfidenceScore
//        }
//        return fuzzyMatchedMedia
//    }
    
//    private func getMediaWithFuzzyMatchedArtist(_ artist: String) -> [MPMediaItem] {
//        guard let allMedia = MediaLibraryHandler.mediaItems else { return [] }
//        let fuzzyMatchedMedia = allMedia.filter { (item) -> Bool in
//            guard let itemArtist = item.artist else { return false }
//            return itemArtist.fuzzyMatchPattern(artist) != nil || artist.fuzzyMatchPattern(itemArtist) != nil
////            let confidence = getConfidenceScore(confidenceOfItem: itemArtist.confidenceScore(artist), confidenceOfTrack: artist.confidenceScore(itemArtist))
////            return confidence < maxConfidenceScore
//        }
//        return fuzzyMatchedMedia
//    }
    
//    private func getConfidenceScore(confidenceOfItem: Double?, confidenceOfTrack: Double?) -> Double {
//        if confidenceOfItem == nil && confidenceOfTrack == nil { return 0.999 }
//
//        if let itemConfidence = confidenceOfItem, confidenceOfTrack == nil { return itemConfidence }
//
//        if let trackConfidence = confidenceOfTrack, confidenceOfItem == nil { return trackConfidence }
//
//        if let itemConfidence = confidenceOfItem, let trackConfidence = confidenceOfTrack {
//            return itemConfidence < trackConfidence ? itemConfidence : trackConfidence
//        }
//
//        return 0.999 //should never reach here
//    }
    
}

enum MediaProperty {
    case Collection
    case Genre
}
