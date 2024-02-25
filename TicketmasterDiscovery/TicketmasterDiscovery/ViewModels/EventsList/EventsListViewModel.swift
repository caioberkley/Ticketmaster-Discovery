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
    @Published var events: [EventModel] = [] {
            didSet {
                DispatchQueue.main.async {
                    self.objectWillChange.send()
                }
            }
        }
    
    private var keyword: String = ""
    private var currentPage: Int = -1
    private var reachedLastPage: Bool = false
    private var isFetchingNextPage: Bool = false
    private var cancellables = Set<AnyCancellable>()
    
    private let service = NetworkService()
    
    func eventViewModel(for event: EventModel) -> EventViewModel? {
        guard event.embedded.venues.first != nil else { return nil }
        return EventViewModel(event: event)
    }
    
    func loadNextPageIfNeeded(event: EventModel) {
        if let lastEvent = events.last, event.id == lastEvent.id {
            loadNextPage()
        }
    }
    
    func loadNextPage() {
        guard !isFetchingNextPage && !reachedLastPage else { return }
        
        let nextPage = currentPage + 1
        isFetchingNextPage = true
        
        let allEventsPublisher = service.loadEvents(pageNumber: nextPage, keyword: keyword)
        
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
            } receiveValue: { [weak self] networkEmbedded in
                let newEvents = networkEmbedded.embedded.events
                self?.events.append(contentsOf: newEvents)
                self?.currentPage = nextPage
                self?.reachedLastPage = newEvents.isEmpty
            }
            .store(in: &cancellables)
    }
    
    func initialDataLoad() async {
        currentPage = -1
        await fetchData()
    }
    
    func refreshData() async {
        currentPage = -1
        DispatchQueue.main.async {
            self.events = []
        }
        reachedLastPage = false
        await fetchData()
    }
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
    }
    
    private func fetchData() async {
        loadNextPage()
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
