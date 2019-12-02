//
//  StockCollectionViewCell.swift
//  weather-news
//
//  Created by Eric Cha on 11/29/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import UIKit
import Charts

class StockCollectionViewCell: UICollectionViewCell, ChartViewDelegate {
    
    @IBOutlet weak var lineChart: LineChartView!
    @IBOutlet weak var newLabel: UILabel!
    
    let gradientFirstColor = UIColor(hex: "ff8181").cgColor
    let gradientSecondColor = UIColor(hex: "a81382").cgColor
    let cellsShadowColor = UIColor(hex: "2a002a").cgColor
    
    override func awakeFromNib() {
        lineChart.delegate = self
        
        lineChart.chartDescription?.enabled = false
        lineChart.dragEnabled = true
        lineChart.setScaleEnabled(true)
        lineChart.pinchZoomEnabled = true
    }
    
    func configureStockCell(_ cell: StockCollectionViewCell,_ stock: Stock) {
        newLabel.text = stock.metaData.symbol
        
        var dataEntries: [ChartDataEntry] = []
        
        for i in 0..<stock.timeSeries.count{
            let dataEntry = ChartDataEntry(x: Double(i) , y: Double(stock.timeSeries[i].close)!)
            dataEntries.append(dataEntry)
        }
        
        let lineChartDataSet = LineChartDataSet(entries: dataEntries, label: "Price")
        lineChartDataSet.circleColors = [UIColor.black]
        lineChartDataSet.circleRadius = 0.1
        lineChartDataSet.drawValuesEnabled = false
        lineChartDataSet.drawFilledEnabled = true
        lineChartDataSet.colors = [UIColor.black]
        let lineChartData = LineChartData(dataSet: lineChartDataSet)
        
        cell.lineChart.data = lineChartData
        cell.lineChart.fitScreen()
        
        configureCell(cell)
    }
    
    func configureCell(_ cell: StockCollectionViewCell) {
        
        cell.clipsToBounds = false
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = cell.bounds
        gradientLayer.colors = [gradientFirstColor, gradientSecondColor]
        gradientLayer.cornerRadius = 21
        gradientLayer.masksToBounds = true
        cell.layer.insertSublayer(gradientLayer, at: 0)
        
        cell.layer.shadowColor = cellsShadowColor
        cell.layer.shadowOpacity = 0.2
        cell.layer.shadowRadius = 20
        cell.layer.shadowOffset = CGSize(width: 0.0, height: 30)
                
        cell.newLabel.layer.cornerRadius = 8
        cell.newLabel.clipsToBounds = true
        cell.newLabel.layer.borderColor = UIColor.white.cgColor
        cell.newLabel.layer.borderWidth = 1.0
    }
}
