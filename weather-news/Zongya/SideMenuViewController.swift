//
//  SideMenuViewController.swift
//  containerExpand
//
//  Created by Zongya Chen on 12/2/19.
//  Copyright © 2019 Zongya. All rights reserved.
//

import UIKit

protocol SideMenuProtocol {
    func searchBtn()
    func resetBtn()
}

class SideMenuViewController: UIViewController {
    
    var SideMenuProtocolDelegate: SideMenuProtocol?

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    @IBAction func search(_ sender: UIButton) {
        SideMenuProtocolDelegate?.searchBtn()
        dismiss(animated: true, completion: nil)
    }
}
