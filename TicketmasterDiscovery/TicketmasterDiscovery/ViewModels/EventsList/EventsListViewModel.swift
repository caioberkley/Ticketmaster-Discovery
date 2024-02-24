//
//  EventsListViewModel.swift
//  TicketmasterDiscovery
//
//  Created by Caio Berkley on 24/02/24.
//

import Foundation
import Combine

class EventsListViewModel: ObservableObject {
    @Published var events: [EventModel] = []
    
    private var keyword: String = ""
    private var currentPage: Int = 0
    private var reachedLastPage: Bool = false
    private var isFetchingNextPage: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private let service = NetworkService()
    
    let pageSize = 20
    
    func loadNextPageIfNeeded(event: EventModel) {
        if let lastEvent = events.last, event.id == lastEvent.id {
            loadNextPage()
        }
    }
    
    func loadNextPage() {
        guard !isFetchingNextPage && !reachedLastPage else { return }
        
        isFetchingNextPage = true
        let nextPage = currentPage + 1
        
        let allEventsPublisher = service.loadEvents(pageNumber: nextPage, pageSize: pageSize, keyword: keyword)
        
        allEventsPublisher
            .receive(on: DispatchQueue.main)
            .sink { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isFetchingNextPage = false
                case .failure(let error):
                    print("Error loading events: \(error)")
                    self?.isFetchingNextPage = false
                }
            } receiveValue: { [weak self] networkResponses in
                let newEvents = networkResponses.flatMap { $0.events }
                DispatchQueue.main.async {
                    self?.events.append(contentsOf: newEvents)
                }
                self?.currentPage = nextPage
                self?.reachedLastPage = newEvents.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func initialDataLoad() async {
        await fetchData()
    }
    
    func refreshData() async {
        currentPage = 0
        DispatchQueue.main.async {
            self.events = []
        }
        reachedLastPage = false
        await fetchData()
    }
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
    }
    
    func fetchData() async {
        loadNextPage()
    }
}
