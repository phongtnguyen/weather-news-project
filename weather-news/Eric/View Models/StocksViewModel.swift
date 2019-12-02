//
//  StocksViewModel.swift
//  StockApp
//
//  Created by Eric Cha on 11/27/19.
//  Copyright © 2019 Eric Cha. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct StockListViewModel {
    var stocksVM: [StockViewModel]
    
    init(_ stocks: [Stock]) {
        self.stocksVM = stocks.compactMap(StockViewModel.init)
    }
    
    func stockAt(_ index: Int) -> StockViewModel{
        return self.stocksVM[index]
    }
    
    var count: Observable<Int> {
        return Observable<Int>.just(stocksVM.count)
    }
}

struct StockViewModel {
    let stock: Stock
    
    init(_ stock: Stock) {
        self.stock = stock
    }
    
    var companyName: Observable<String> {
        return Observable<String>.just(stock.companyName ?? "")
    }
    var metaData: Observable<MetaData> {
        return Observable<MetaData>.just(stock.metaData)
    }
    var timeSeries: Observable<[TimeSeriesDaily]> {
        return Observable<[TimeSeriesDaily]>.from(optional: stock.timeSeries)
    }
}

