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
        let vc = UIStoryboard(name: "Zongya", bundle: nil).instantiateViewController(withIdentifier: "tryViewController")
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openEricView(_ sender: UIButton) {
        let sb = UIStoryboard(name: "Eric", bundle: nil)
        var vc: StockViewController
        if #available(iOS 13.0, *) {
            vc = sb.instantiateViewController(identifier: "StockViewController") as! StockViewController
        } else {
            vc = sb.instantiateViewController(withIdentifier: "StockViewController") as! StockViewController
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openPhongView(_ sender: UIButton) {
        let vc = ItunesViewController()
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openJustinView(_ sender: UIButton) {
        let st = UIStoryboard(name: "Justin", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "HoroscopeViewController") as UIViewController
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func openChanyeView(_ sender: UIButton) {
        let st = UIStoryboard(name: "WeatherScreen", bundle: nil)
        let vc = st.instantiateViewController(withIdentifier: "WeatherViewController") as UIViewController
        navigationController?.pushViewController(vc, animated: true)
//        present(vc, animated: true, completion: nil)
    }
    
}
