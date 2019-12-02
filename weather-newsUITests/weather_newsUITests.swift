//
//  weather_newsUITests.swift
//  weather-newsUITests
//
//  Created by Phong Nguyen on 12/4/19.
//  Copyright © 2019 Phong Nguyen. All rights reserved.
//

import XCTest

class weather_newsUITests: XCTestCase {
    var app: XCUIApplication?
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        app = XCUIApplication()
        app?.launch()
        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        app = nil
    }

    func testExample() {
        
        let app = XCUIApplication()
        let menuButton = app.navigationBars["weather_news.View"].buttons["Menu"]
        menuButton.tap()
        
        let itunesButton = app.buttons["iTunes"]
        itunesButton.tap()
        
        let searchForSongsSearchField = app.searchFields["Search for songs..."]
        searchForSongsSearchField.tap()
        
        let backButton = app.navigationBars["weather_news.ItunesView"].buttons["Back"]
        backButton.tap()
        menuButton.tap()
        itunesButton.tap()
        searchForSongsSearchField.tap()
        searchForSongsSearchField.tap()
        backButton.tap()
        menuButton.tap()
        itunesButton.tap()
        searchForSongsSearchField.tap()
        searchForSongsSearchField.tap()
        
    }

    func testLaunchPerformance() {
        if #available(macOS 10.15, iOS 13.0, tvOS 13.0, *) {
            // This measures how long it takes to launch your application.
            measure(metrics: [XCTOSSignpostMetric.applicationLaunch]) {
                XCUIApplication().launch()
            }
        }
    }
}
