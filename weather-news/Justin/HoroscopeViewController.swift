//
//  HoroscopeViewController.swift
//  GoodWeather
//
//  Created by Macbook on 12/1/19.
//  Copyright © 2019 Mohammad Azam. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift
import Gemini

class HoroscopeViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    
    @IBOutlet weak var horoscopeTextView: UITextView!
    @IBOutlet weak var collectionView: GeminiCollectionView!
    //Aries, Taurus, Gemini, Cancer, Leo, Virgo, Libra, Scorpio, Sagittarius, Capricorn, Aquarius and Pisces
    
    let dataArray = [
        sign(signName: "Aries", signImage: UIImage(named: "aries")!),
        sign(signName: "Taurus", signImage: UIImage(named: "taurus")!),
        sign(signName: "Gemini", signImage: UIImage(named: "gemini")!),
        sign(signName: "Cancer", signImage: UIImage(named: "cancer")!),
        sign(signName: "Leo", signImage: UIImage(named: "leo")!),
        sign(signName: "Virgo", signImage: UIImage(named: "virgo")!),
        sign(signName: "Libra", signImage: UIImage(named: "libra")!),
        sign(signName: "Scorpio", signImage: UIImage(named: "scorpio")!),
        sign(signName: "Sagittarius", signImage: UIImage(named: "sagittarius")!),
        sign(signName: "Capricorn", signImage: UIImage(named: "capricorn")!),
        sign(signName: "Aquarius", signImage: UIImage(named: "aquarius")!),
        sign(signName: "Pisces", signImage: UIImage(named: "pisces")!)
    ]
    
    var infoArray : [String] = []
    
    let disposeBag = DisposeBag()
    var screenSize: CGRect!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAnimation()
        //fetchAllData()
        // Do any additional setup after loading the view.
    }
    
    func fetchAllData() {
        let dispatchGroup = DispatchGroup()
        
        for info in dataArray {
            dispatchGroup.enter()
            fetchData(sign: info.signName)
            dispatchGroup.leave()
        }
        
        dispatchGroup.notify(queue: DispatchQueue.main) {
            self.collectionView.reloadData()
        }
        
    }
    
    func configureAnimation() {
        collectionView.gemini
            .customAnimation()
            .translation(x: 0, y: 60, z: 0)
            .rotationAngle(x: 0, y: 20, z: 0)
            .ease(.easeOutExpo)
            .shadowEffect(.fadeIn)
            .maxShadowAlpha(0.3)
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        collectionView.animateVisibleCells()
    }
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if let cell = cell as? GeminiCell {
            self.collectionView.animateCell(cell)
        }
    }
    
    
    
    func fetchData(sign : String) {
        
        guard let url = URL.urlForHoroscope(sign: sign) else {
            return
        }
        
        let resource = Resource<Horoscope>(url: url)
        
        let search = URLRequest.load(resource: resource)
            .observeOn(MainScheduler.instance)
            .asDriver(onErrorJustReturn: Horoscope.empty)
        
        search.map { "\($0.horoscope)" }
            .drive(self.horoscopeTextView.rx.text)
            .disposed(by: disposeBag)
        //        search.drive(onNext: { (horoscopeObject) in
        //            self.infoArray.append(horoscopeObject.horoscope)
        //        }, onCompleted: {
        //            print("onCompleted")
        //        }) {
        //            //
        //        }
        
        //        search.do(onNext: { (horoscopeObject) in
        //            self.infoArray.append(horoscopeObject.horoscope)
        //        }, onCompleted: {
        //            print("onCompleted")
        //        }, onSubscribe: {
        //            print("onSubscribe")
        //        }, onSubscribed: {
        //            print("onSubscribe")
        //        }) {
        //            //
        //        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let sign = dataArray[indexPath.row]
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath) as! HoroscopeCollectionViewCells
        
        cell.imageLbl.text = sign.signName
        cell.imageView.image = sign.signImage
        
        cell.layer.masksToBounds = true
        cell.layer.cornerRadius = 50
        
        self.collectionView.animateCell(cell)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: collectionView.frame.size.width / 2, height: collectionView.frame.size.width - 120)
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let signName = dataArray[indexPath.row].signName
        fetchData(sign: signName)
    }
}


struct sign {
    let signName : String
    let signImage: UIImage
}
