//
//  ItunesURLHandler.swift
//  ItunesPreviewRxSwift
//
//  Created by Phong Nguyen on 12/1/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import Foundation
import RxAlamofire
import RxCocoa
import RxSwift

class ItunesURLHandler {
    
    func requestData(with url: URL) -> Observable<Data> {
        return Observable.just(url)
            .flatMap ({ (url) -> Observable<(HTTPURLResponse, Data)> in
                return RxAlamofire.requestData(.get, url)
            })
            .map ({ (reponse, data) -> Data in
                return data
            })
    }
    
}
