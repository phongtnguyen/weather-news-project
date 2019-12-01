//
//  SideBarViewController.swift
//  weather-news
//
//  Created by Zongya Chen on 11/27/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit

class SideBarViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func openZongyaView(_ sender: UIButton) {
        
    }
    
    @IBAction func openEricView(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Eric", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "StockViewController") as! StockViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openPhongView(_ sender: UIButton) {
        //let st = UIStoryboard(name: "Phong_Storyboard", bundle: nil)
        
    }
    
    @IBAction func openJustinView(_ sender: UIButton) {
        
    }
    
    @IBAction func openChanyeView(_ sender: UIButton) {
        
    }
    
}
