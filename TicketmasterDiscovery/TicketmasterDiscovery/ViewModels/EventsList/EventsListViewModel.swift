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
    @Published var isEventListEmpty: Bool = false

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
                    self?.isEventListEmpty = true
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
            self.isEventListEmpty = false
        }
        reachedLastPage = false
        fetchData()
    }
    
    func cancel() {
        cancellables.forEach { $0.cancel() }
    }
}

//MARK: - WebView
struct WebView: UIViewRepresentable {
    let url: URL
    @Binding var isWebViewLoading: Bool

    func makeUIView(context: Context) -> WKWebView  {
        let webView = WKWebView()
        webView.load(URLRequest(url: url))
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        if uiView.url == nil {
            uiView.load(URLRequest(url: url))
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        var parent: WebView
        
        init(parent: WebView) {
            self.parent = parent
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            parent.isWebViewLoading = true
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            parent.isWebViewLoading = false
        }
    }
}

// MARK: - NetworkMonitor
class NetworkMonitor: ObservableObject {
    private let monitor: NWPathMonitor
    private let queue = DispatchQueue(label: "Monitor")
    
    @Published var isConnected: Bool
    
    init() {
        self.monitor = NWPathMonitor()
        self.isConnected = true
        
        self.monitor.pathUpdateHandler = { path in
            DispatchQueue.main.async {
                self.isConnected = path.status == .satisfied
            }
        }
        
        self.monitor.start(queue: self.queue)
    }
}

