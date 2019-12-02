//
//  MediaCell.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 11/30/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit
import MediaPlayer
import SwifterSwift

class MediaCell: UITableViewCell {

    var song: MPMediaItem? {
        didSet {
            if let song = song {
                title.text = (song.title ?? "NO TITLE INFO")
                artist.text = (song.artist ?? "NO ARTIST INFO")
                artwork.image = song.artwork?.image(at: CGSize(width: 40, height: 40))
            }
        }
    }
    let artwork = UIImageView()
    let artist = UILabel()
    let title = UILabel()
    
    func configure() {
        
        contentView.addSubviews([artwork, artist, title])
        
        artist.configure(font: .systemFont(ofSize: 14, weight: .light), textColor: .gray, alignment: .left)
        
        title.configure(font: .systemFont(ofSize: 17, weight: .regular), textColor: .black, alignment: .left)
        
        artwork.configure(contentMode: .scaleAspectFill, borderWidth: 0, borderColor: UIColor.black.cgColor)
        artwork.layer.cornerRadius = 5
        
        // MARK: Constraints
        artwork.addConstraintsWithWidthEqualHeight(yAnchor: artwork.topAnchor, by: 5, to: contentView.topAnchor, xAnchor: artwork.leadingAnchor, by: 5, to: contentView.leadingAnchor, size: 40)
        title.threeSidesConstraintWithHeight(yAnchor: title.topAnchor, yConstant: 5, toYAnchor: contentView.topAnchor, leftAnchor: artwork.rightAnchor, leftConstant: 10, rightAnchor: contentView.rightAnchor, rightConstant: -20, heightConstant: 22)
        artist.threeSidesConstraintWithHeight(yAnchor: artist.topAnchor, yConstant: 0, toYAnchor: title.bottomAnchor, leftAnchor: artwork.rightAnchor, leftConstant: 10, rightAnchor: contentView.rightAnchor, rightConstant: -20, heightConstant: 18)
    }

}
