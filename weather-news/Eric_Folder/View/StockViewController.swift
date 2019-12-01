//
//  StockViewController.swift
//  StockApp
//
//  Created by Eric Cha on 11/27/19.
//  Copyright © 2019 Eric Cha. All rights reserved.
//

import UIKit
import GravitySliderFlowLayout
import RxSwift

class StockViewController: UIViewController {
    
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var stockTitleLabel: UILabel!
    @IBOutlet weak var openLabel: UILabel!
    @IBOutlet weak var highLabel: UILabel!
    @IBOutlet weak var lowLabel: UILabel!
    @IBOutlet weak var closeLabel: UILabel!
    @IBOutlet weak var volumeLabel: UILabel!
    
    let disposeBag = DisposeBag()
    let queryService = QueryService()
    
    var stocks: Set = ["T", "SBUX", "AAPL"]
    var searchResults = [Stock]()
    
    let collectionViewCellHeightCoefficient: CGFloat = 0.85
    let collectionViewCellWidthCoefficient: CGFloat = 0.55
    let priceButtonCornerRadius: CGFloat = 10
    
    private var itemsNumber = 1000
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getStocks()
        configureCollectionView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        collectionView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0) {
            print(self.searchResults.count)
            for stock in self.searchResults {
                print(stock.metaData.symbol)
            }
            self.collectionView.reloadData()
        }
    }
    
    private func getStocks() {
        for stock in stocks {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                self.queryService.getStockResults(searchTerm: stock) { [weak self] results, errorMessage in
                    if let results = results {
                        self?.searchResults.append(results)
                    }
                    
                    if !errorMessage.isEmpty {
                        print("Search error: " + errorMessage)
                    }
                }
            }
        }
    }
    private func getStock(_ stock: String) {
        self.queryService.getStockResults(searchTerm: stock) { [weak self] results, errorMessage in
            if let results = results {
                self?.searchResults.append(results)
            }
            
            if !errorMessage.isEmpty {
                print("Search error: " + errorMessage)
            }
        }
        
    }
    
    private func configureCollectionView() {
        let gravitySliderLayout = GravitySliderFlowLayout(with: CGSize(width: collectionView.frame.size.height * collectionViewCellWidthCoefficient, height: collectionView.frame.size.height * collectionViewCellHeightCoefficient))
        collectionView.collectionViewLayout = gravitySliderLayout
        collectionView.dataSource = self
        collectionView.delegate = self
    }
    
    private func animateChangingTitle(for indexPath: IndexPath) {
        UIView.transition(with: stockTitleLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            self.stockTitleLabel.text = self.searchResults[indexPath.row % self.searchResults.count].metaData.symbol
        }, completion: nil)
        UIView.transition(with: openLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let open = self.searchResults[indexPath.row % self.searchResults.count].timeSeries.last?.open as! String
            self.openLabel.text = "Open:  \(open)"
        }, completion: nil)
        UIView.transition(with: highLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let high = self.searchResults[indexPath.row % self.searchResults.count].timeSeries.last?.high as! String
            self.highLabel.text = "High:  \(high)"
        }, completion: nil)
        UIView.transition(with: lowLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let low = self.searchResults[indexPath.row % self.searchResults.count].timeSeries.last?.low as! String
            self.lowLabel.text = "Low:  \(low)"
        }, completion: nil)
        UIView.transition(with: closeLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let close = self.searchResults[indexPath.row % self.searchResults.count].timeSeries.last?.close as! String
            self.closeLabel.text = "Close:  \(close)"
        }, completion: nil)
        UIView.transition(with: volumeLabel, duration: 0.3, options: .transitionCrossDissolve, animations: {
            let volume = self.searchResults[indexPath.row % self.searchResults.count].timeSeries.last?.volume as! String
            self.volumeLabel.text = "Volume:  \(volume)"
        }, completion: nil)
    }
    
    @IBAction func goToSearch(_ sender: Any) {
        let sb = UIStoryboard(name: "Eric", bundle: nil)
        let vc = sb.instantiateViewController(identifier: "SearchViewController") as! SearchViewController
        navigationController?.pushViewController(vc, animated: true)
        vc.selectedStockSubject.subscribe(onNext: { [weak self] symbol in
            self?.stocks.insert(symbol)
            self?.getStock(symbol)
        }).disposed(by: disposeBag)
    }
}

extension StockViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return itemsNumber
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "StockCollectionViewCell", for: indexPath) as! StockCollectionViewCell
        if searchResults.count > 0 {
            let stock = searchResults[indexPath.row % self.searchResults.count]
            cell.configureStockCell(cell, stock, for: indexPath)
        }else {
            cell.configureCell(cell, for: indexPath)
        }
        return cell
    }
    
    
}

extension StockViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let locationFirst = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x, y: collectionView.center.y + scrollView.contentOffset.y)
        let locationSecond = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x + 20, y: collectionView.center.y + scrollView.contentOffset.y)
        let locationThird = CGPoint(x: collectionView.center.x + scrollView.contentOffset.x - 20, y: collectionView.center.y + scrollView.contentOffset.y)
        
        if let indexPathFirst = collectionView.indexPathForItem(at: locationFirst), let indexPathSecond = collectionView.indexPathForItem(at: locationSecond), let indexPathThird = collectionView.indexPathForItem(at: locationThird), indexPathFirst.row == indexPathSecond.row && indexPathSecond.row == indexPathThird.row  {
            self.animateChangingTitle(for: indexPathFirst)
        }
    }
}
