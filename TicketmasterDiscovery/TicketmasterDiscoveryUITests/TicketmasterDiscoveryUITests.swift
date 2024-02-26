//
//  TicketmasterDiscoveryUITests.swift
//  TicketmasterDiscoveryUITests
//
//  Created by Caio Berkley on 23/02/24.
//

import XCTest

final class TicketmasterDiscoveryUITests: XCTestCase {
    
    var app: XCUIApplication!
    
    override func setUpWithError() throws {
        app = XCUIApplication()
        app.launch()
    }
    
    override func tearDownWithError() throws {
        app = nil
    }
    
    func testSearchEvents() throws {
        // Wait the app first load
        XCTAssertTrue(app.navigationBars["Ticketmaster"].exists)
        
        //Write a word in the Search Bar
        let searchBar = app.searchFields.element
                searchBar.tap()
        searchBar.typeText("Concert")
        
        // Verify if the word is correct at the Search Bar
        XCTAssertEqual(searchBar.value as! String, "Concert")
        
        // Touch the Search Bar
        app.keyboards.buttons["Search"].tap()
        
        // Wait the results of the search
        XCTAssertTrue(app.activityIndicators.firstMatch.exists)
        
        // Wait the Event List appear
        XCTAssertTrue(app.tables.firstMatch.exists)
        
        // Verify if the event is visible on the list
        let eventCell = app.cells.firstMatch
        XCTAssertTrue(eventCell.exists)
        
        // Touch on the card to open Web View
        eventCell.tap()
        
        // Wait the Web View load
        XCTAssertTrue(app.webViews.firstMatch.waitForExistence(timeout: 10))
        
        // Back to the Event List
        app.navigationBars.buttons.element(boundBy: 0).tap()
        
        // Clean the search bar
        searchBar.tap()
        searchBar.buttons["Clear text"].tap()
    }
}
