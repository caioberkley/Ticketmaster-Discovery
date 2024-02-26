//
//  EventsListViewModel.swift
//  TicketmasterDiscovery
//
//  Created by Caio Berkley on 24/02/24.
//

import SwiftUI
import Combine
import WebKit

class EventsListViewModel: ObservableObject {
    @Published var events: [EventModel] = []
    @Published var keyword: String = ""
    
    var currentPage: Int = -1
    var reachedLastPage: Bool = false
    var isFetchingNextPage: Bool = false
    var cancellables = Set<AnyCancellable>()
    
    private let service = NetworkService()
    
    func eventViewModel(for event: EventModel) -> EventViewModel? {
        guard event.embedded.venues.first != nil else { return nil }
        return EventViewModel(event: event)
    }
    
    func loadNextPageIfNeeded(event: EventModel) {
        if let lastEvent = events.last, event.id == lastEvent.id {
            fetchData()
        }
    }
    
    func fetchData() {
        guard !isFetchingNextPage && !reachedLastPage else { return }
        
        let nextPage = currentPage + 1
        isFetchingNextPage = true
        
        let allEventsPublisher = service.loadEvents(pageNumber: nextPage, keyword: keyword)
        
        allEventsPublisher
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { [weak self] completion in
                switch completion {
                case .finished:
                    self?.isFetchingNextPage = false
                case .failure(let error):
                    print("Error loading events: \(error)")
                    self?.isFetchingNextPage = false
                }
            }, receiveValue: { [weak self] networkEmbedded in
                let newEvents = networkEmbedded.embedded.events
                DispatchQueue.main.async {
                    self?.events.append(contentsOf: newEvents)
                    self?.currentPage = nextPage
                    self?.reachedLastPage = newEvents.isEmpty
                }
            })
            .store(in: &cancellables)
    }
    
    func initialDataLoad() async {
        currentPage = -1
        fetchData()
    }
    
    private func refreshDataWrapper() {
        Task {
            await refreshDataAsync()
        }
    }
    
    func runSearch(keyword: String) async {
        self.keyword = keyword
        currentPage = -1
        DispatchQueue.main.async {
            self.events = []

        }
        reachedLastPage = false
        fetchData()
    }
    
    func refreshDataAsync() async {
        self.keyword = ""
        currentPage = -1
        DispatchQueue.main.async {
            self.events = []
            
        }
        reachedLastPage = false
        fetchData()
    }
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
    }
}

struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url == nil {
            uiView.load(URLRequest(url: url))
        }
    }
}
