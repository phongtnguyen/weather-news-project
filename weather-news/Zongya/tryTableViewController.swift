//
//  tryTableViewController.swift
//  containerExpand
//
//  Created by Zongya Chen on 12/1/19.
//  Copyright © 2019 Zongya. All rights reserved.
//

import UIKit
import expanding_collection
import SafariServices

class tryTableViewController: ExpandingTableViewController {
    

    @IBOutlet weak var contentLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var titleCell: UITableViewCell!
    
    var newsUrl: String?
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none
        navigationItem.hidesBackButton = true  
    }
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        headerHeight = 236
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        headerHeight = 236
    }
    
    @IBAction func backButtonHandler(_ sender: Any) {
        popTransitionAnimation()
    }
    
    @IBAction func openInSafari(_ sender: UIButton) {
        guard let url = URL(string: newsUrl ?? "") else { return }
        UIApplication.shared.open(url)
    }
}
