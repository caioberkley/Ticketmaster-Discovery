//
//  TicketmasterDiscoveryTests.swift
//  TicketmasterDiscoveryTests
//
//  Created by Caio Berkley on 23/02/24.
//

import XCTest
import Combine
@testable import TicketmasterDiscovery

class TicketmasterDiscoveryTests: XCTestCase {
    var viewModel: EventsListViewModel!
    var cancellables = Set<AnyCancellable>()
    
    override func setUp() {
        super.setUp()
        viewModel = EventsListViewModel()
    }
    
    override func tearDown() {
        cancellables.removeAll()
        viewModel = nil
        super.tearDown()
    }
    
    func testFetchData() {
        let expectation = expectation(description: "Data fetched")
        
        viewModel.fetchData()
        
        let cancellable = viewModel.$events.sink { events in
            if !events.isEmpty {
                expectation.fulfill()
            }
        }
        
        wait(for: [expectation], timeout: 5)
        cancellable.cancel()
    }
    
    func testInitialDataLoad() {
        let expectation = expectation(description: "Initial data loaded")
        
        Task {
            await viewModel.initialDataLoad()
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    func testEventWithVenue() {
        let eventWithVenue = EventModel(name: "The Taylor Party - Taylor Swift Night", id: "1", url: "https://ticketmaster.com", images: [], dates: EventDate(start: StartDate(localDate: "2024-01-07")), ageRestrictions: AgeRestrictions(legalAgeEnforced: true), embedded: EventEmbedded(venues: [Venue(name: "Theatre of Living Arts", city: VenueCity(name: "Philadelphia"), state: VenueState(stateCode: "PA"))]))
        
        XCTAssertNotNil(viewModel.eventViewModel(for: eventWithVenue))
    }
    
    func testEventWithoutVenue() {
        let eventWithoutVenue = EventModel(name: "Test Event Without Venue", id: "2", url: "https://example.com", images: [], dates: EventDate(start: StartDate(localDate: "2024-02-26")), ageRestrictions: nil, embedded: EventEmbedded(venues: []))
        
        XCTAssertNil(viewModel.eventViewModel(for: eventWithoutVenue))
    }
    
    func testLoadNextPageIfNeeded() {
        let event1 = EventModel(name: "Page 1", id: "1", url: "https://example.com", images: [], dates: EventDate(start: StartDate(localDate: "2024-02-26")), ageRestrictions: nil, embedded: EventEmbedded(venues: []))
        let event2 = EventModel(name: "Page 2", id: "2", url: "https://example.com", images: [], dates: EventDate(start: StartDate(localDate: "2024-02-26")), ageRestrictions: nil, embedded: EventEmbedded(venues: []))
        
        viewModel.events = [event1]
        
        viewModel.loadNextPageIfNeeded(event: event2)
        
        XCTAssertTrue(viewModel.isFetchingNextPage)
    }
    
    func testRunSearch() async {
        let expectation = XCTestExpectation(description: "Run Search")
        
        let keyword = "test"
        await viewModel.runSearch(keyword: keyword)
        
        await fulfillment(of: [expectation], timeout: 5)
        
        XCTAssertEqual(self.viewModel.keyword, keyword)
        XCTAssertTrue(self.viewModel.events.isEmpty)
    }
}
