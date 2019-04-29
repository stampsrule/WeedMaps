//
//  WeedmapsChallengeUITests.swift
//  WeedmapsChallengeUITests
//
//  Created by Mark Anderson on 10/5/18.
//  Copyright © 2018 Weedmaps, LLC. All rights reserved.
//

import XCTest

class WeedmapsChallengeUITests: XCTestCase {

    var app: XCUIApplication!
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // UI tests must launch the application that they test. Doing this in setup will make sure it happens for each test method.
        app = XCUIApplication()
        app.launch()

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testTabBarTitleLabelsExist() {
        XCTAssertTrue(app.staticTexts["Home Title Label"].exists)
        app.tabBars.buttons["Favorites"].tap()
        XCTAssertTrue(app.staticTexts["Favorites Title Label"].exists)
    }
    
    func testSearchBar() {
        let app = XCUIApplication()
        app.children(matching: .window).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element.children(matching: .other).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.children(matching: .collectionView).element.swipeDown()
        
        XCTAssertTrue(app.searchFields["Search Businesses"].exists)
        let searchBusinessesSearchField = app.searchFields["Search Businesses"]
        searchBusinessesSearchField.tap()
        
        let wKey = app.keys["W"]
        let eKey = app.keys["e"]
        let dKey = app.keys["d"]
        let searchButton = app.buttons["Search"]
        
        wKey.tap()
        eKey.tap()
        eKey.tap()
        dKey.tap()
        searchButton.tap()
        
        app.collectionViews.children(matching: .cell).element(boundBy: 0).children(matching: .other).element.children(matching: .other).element.tap()
        
        XCTAssertTrue(app.sheets["Show Details"].exists)
        XCTAssertTrue(app.sheets["Show Details"].buttons["In App"].exists)
        app.sheets["Show Details"].buttons["In App"].tap()
        
    }
}
