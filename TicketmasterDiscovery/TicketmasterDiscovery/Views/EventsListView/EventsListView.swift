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
    @State private var isLoading = false
    
    var body: some View {
        NavigationStack {
            ZStack {
                Color.white.ignoresSafeArea()
                List(viewModel.events, id: \.id) { event in
                    NavigationLink(
                        destination: WebView(url: (URL(string: event.url) ?? URL(string: "https://www.ticketmaster.com"))!)
                    ) {
                        if let eventViewModel = viewModel.eventViewModel(for: event) {
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
            .navigationBarTitle("Ticketmaster")
                .onAppear {
                    UINavigationBar.appearance().largeTitleTextAttributes = [.foregroundColor: UIColor.tintColor]
                }
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

struct EventsListView_Previews: PreviewProvider {
    static var previews: some View {
        let viewModel = EventsListViewModel()
        return EventsListView()
            .environmentObject(LaunchScreenStateManager())
            .environmentObject(viewModel)
    }
}
