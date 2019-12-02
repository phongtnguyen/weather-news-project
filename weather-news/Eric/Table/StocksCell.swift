//
//  StocksTableViewCell.swift
//  StockApp
//
//  Created by Eric Cha on 11/27/19.
//  Copyright © 2019 Eric Cha. All rights reserved.
//

import UIKit

class StocksCell: UITableViewCell {
    
    //
    // MARK: - IBOutlets
    //
    @IBOutlet weak var symbolLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    //
    // MARK: - Internal Methods
    //
    func configure(stock: BestMatch) {
        symbolLabel.text = stock.symbol
        nameLabel.text = stock.name
    }
}
