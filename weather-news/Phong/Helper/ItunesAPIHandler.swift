//
//  ItunesAPIHandler.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/1/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import RxAlamofire
import RxCocoa
import RxSwift

class ItunesAPIHandler<T: Codable> {
    
    let bag = DisposeBag()
    let model: T.Type?
    
    var observable: BehaviorRelay<T?>?
    
    init(_ model: T.Type) {
        self.model = model
        self.observable = BehaviorRelay<T?>(value: nil)
    }
    
    func requestData(with url: URL) { // first search doesn't return till click search a second time
        
        guard let model = model else { print("No model \(self.model)"); return }
        
        RxAlamofire.requestData(.get, url).subscribe(onNext: { [weak self] (response, data) in
            print ("Got \(data) with response => \(response.statusCode)")
            guard response.statusCode == 200 else {
                print ("Unsuccessful status code: \(response.statusCode)")
                return
            }
            
            self?.observable?.accept(try? JSONDecoder().decode(model, from: data))
        }, onError: { (error) in
            print ("Error ItunesAPIHandler: \(error.localizedDescription)")
            ActivityIndicatorHelper.hideIndicator()
        }, onCompleted: {
            print ("Completed ItunesAPIHandler")
            ActivityIndicatorHelper.hideIndicator()
        }).disposed(by: bag)
        
    }
    
    // not used
    func query(with url: URL) -> Observable<T?> {
        guard let model = model else { print ("Model is nil"); return Observable.just(nil) }
        
        return Observable.just(url)
            .flatMap { (url) -> Observable<(HTTPURLResponse, Data)> in
                return RxAlamofire.requestData(.get, url)
        }.map { (response, data) -> T? in
            return try? JSONDecoder().decode(model, from: data)
        }
    }
    
}
