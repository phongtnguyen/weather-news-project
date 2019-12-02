//
//  NewsCollectionViewCell.swift
//  containerExpand
//
//  Created by Zongya Chen on 12/1/19.
//  Copyright © 2019 Zongya. All rights reserved.
//

import UIKit
import expanding_collection

class NewsCollectionViewCell: BasePageCollectionCell {

    @IBOutlet weak var gapConstraint: NSLayoutConstraint!
    @IBOutlet weak var newsDescription: UILabel!
    @IBOutlet weak var gradientView: UIView!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var title: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        newsDescription.baselineAdjustment = .alignCenters
    }
    
    
}
