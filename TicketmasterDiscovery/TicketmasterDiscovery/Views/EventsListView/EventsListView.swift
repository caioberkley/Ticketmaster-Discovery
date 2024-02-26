//
//  EventsListView.swift
//  TicketmasterDiscovery
//
//  Created by Caio Berkley on 23/02/24.
//

import SwiftUI

struct EventsListView: View {
    @EnvironmentObject private var launchScreenState: LaunchScreenStateManager
    @StateObject private var viewModel = EventsListViewModel()
    @Environment(\.colorScheme) var colorScheme
    @State private var searchKeyword = ""
    @State private var isLoading = false
    @State private var isWebViewLoading: Bool = true
    @State private var networkMonitor = NetworkMonitor()
    
    var body: some View {
        if networkMonitor.isConnected {
            NavigationStack {
                ZStack {
                    List(viewModel.events, id: \.id) { event in
                        let eventViewModel = viewModel.eventViewModel(for: event)
                        NavigationLink(
                            destination: WebView(url: (URL(string: event.url) ?? URL(string: "https://www.ticketmaster.com"))!, isWebViewLoading: $isWebViewLoading)
                        ) {
                            if let eventViewModel = eventViewModel {
                                EventCardView(viewModel: eventViewModel)
                            }
                        }
                        .listRowSeparator(.hidden)
                        .listRowInsets(EdgeInsets(top: 10, leading: 20, bottom: 10, trailing: 6))
                        .listRowBackground(Color.clear.ignoresSafeArea())
                        .onAppear {
                            viewModel.loadNextPageIfNeeded(event: event)
                        }
                    }
                    .searchable(text: $searchKeyword, prompt: "Discovery events!")
                    .onSubmit(of: .search) {
                        Task {
                            await viewModel.runSearch(keyword: searchKeyword)
                        }
                    }
                    .padding(.top, 20)
                    .preferredColorScheme(.light)
                    .refreshable {
                        isLoading = true
                        Task {
                            await viewModel.refreshDataAsync()
                            DispatchQueue.main.async {
                                isLoading = false
                            }
                        }
                    }
                    .listStyle(.plain)
                    .background(colorScheme == .light ? Color.white.ignoresSafeArea() : Color.black.ignoresSafeArea())
                    Group {
                        if isLoading {
                            ProgressView()
                        } else if viewModel.isEventListEmpty {
                            Text("There's no events at the moment.")
                                .foregroundColor(.red)
                                .padding()
                        }
                    }
                }
                .navigationBarTitle("Ticketmaster")
                .onAppear {
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]
                }
            }
            .task {
                isLoading = true
                Task {
                    await viewModel.initialDataLoad()
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
        } else {
            ContentUnavailableView(
                "No Internet Connection",
                systemImage: "wifi.exclamationmark",
                description: Text("Please check your connection and try again.")
            )
        }
    }
}

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = EventsListViewModel()
        return EventsListView()
            .environmentObject(LaunchScreenStateManager())
            .environmentObject(viewModel)
    }
}
