//
//  EventsListView.swift
//  TicketmasterDiscovery
//
//  Created by Caio Berkley on 23/02/24.
//

import SwiftUI
import WebKit

struct EventsListView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
    @StateObject private var viewModel = EventsListViewModel()
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.blue.ignoresSafeArea()
                List(viewModel.events, id: \.id) { event in
                    NavigationLink(
                        destination: WebView(url: (URL(string: event.url) ?? URL(string: "https://www.ticketmaster.com"))!)
                    ) {
                        EventCardView(event: event)
                    }
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets(top: 0, leading: 24, bottom: 24, trailing: 6))
                    .listRowBackground(Color.black.ignoresSafeArea())
                    .onAppear {
                        viewModel.loadNextPageIfNeeded(event: event)
                    }
                }
                .padding(.top, 20)
                .preferredColorScheme(.dark)
                .refreshable {
                    isLoading = true
                    Task {
                        await viewModel.refreshData()
                        DispatchQueue.main.async {
                            isLoading = false
                        }
                    }
                }
                .listStyle(.plain)
                .background(Color.white.ignoresSafeArea())
                
                if isLoading {
                    ProgressView()
                }
            }
            .navigationBarTitle("Events", displayMode: .large)
        }
        .task {
            isLoading = true
            Task {
                await viewModel.initialDataLoad()
                do {
                    try await Task.sleep(for: .seconds(2))
                } catch {
                    print("Error: \(error)")
                }
                DispatchQueue.main.async {
                    self.launchScreenState.dismiss()
                    isLoading = false
                }
            }
        }
        .onDisappear {
            viewModel.cancel()
        }
        .navigationViewStyle(StackNavigationViewStyle())
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
