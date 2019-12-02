//
//  MediaPlayerController.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/2/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import MediaPlayer
import RxSwift
import RxCocoa

class MusicPlayerController {
    static let shared = MusicPlayerController.init(MPMusicPlayerController.applicationMusicPlayer)
    
    private let player: MPMusicPlayerController
    
    var observablePlaybackProgress = BehaviorRelay<Float>(value: 0)
    lazy var timer: Timer = {
        return Timer.scheduledTimer(timeInterval: 0.3, target: self, selector: #selector(updatePlaybackProgress(_:)), userInfo: nil, repeats: true)
    }()
    var playbackQueue: [MPMediaItem] = []
    
    init(_ player: MPMusicPlayerController) {
        self.player = player
    }
    
    init() {
        self.player = MPMusicPlayerController.systemMusicPlayer
    }
    
    func queueSong(with mediaItems: [MPMediaItem]) {
        player.stop()
        player.setQueue(with: MPMediaItemCollection(items: mediaItems))
        player.currentPlaybackTime = 0
        observablePlaybackProgress.accept(0)
    }
    
    func queueSongs(with mediaItems: [MPMediaItem], start index: Int) {
        guard index < mediaItems.count else { print ("queueSongs: invalid start index"); return }
        player.stop()
        playbackQueue = makePlaybackQueueStartAt(index: index, items: mediaItems)
        player.setQueue(with: MPMediaItemCollection(items: playbackQueue))
        player.shuffleMode = .off
        player.repeatMode = .all
        player.currentPlaybackTime = 0
        observablePlaybackProgress.accept(0)
    }
    
    func play() {
        player.play()
        timer.fire()
    }
    
    func pause() {
        player.pause()
    }
    
    func next() {
        player.skipToNextItem()
    }
    
    func isPlaying() -> Bool {
        return player.playbackState == .playing
    }
    
    func nowPlayingItem() -> MPMediaItem? {
        if player.nowPlayingItem != nil { timer.fire() }
        return player.nowPlayingItem
    }
    
    private func makePlaybackQueueStartAt(index: Int, items: [MPMediaItem]) -> [MPMediaItem] {
        if items.count < 2 { return items }
        if index < 1 { return items }
        let playbackQueue = [items[index]] + Array(items[(index+1)...]) + Array(items[..<index])
//        print("playbackQueue => ")
//        for song in playbackQueue {
//            print(song.title ?? "No title", terminator: " –– ")
//        }
//        print()
        return playbackQueue
    }
    
    @objc private func updatePlaybackProgress(_ sender: Timer) {
        guard let currentPlaybackDuration = player.nowPlayingItem?.playbackDuration else { print("No current playing item"); return }
        guard player.playbackState == .playing else { return }
        
        let currentPlaybackTime = player.currentPlaybackTime
        observablePlaybackProgress.accept(Float(currentPlaybackTime / currentPlaybackDuration))
    }
    
    deinit {
        timer.invalidate()
        print ("music player controller deinit")
        player.stop()
        player.currentPlaybackTime = 0
    }
}
