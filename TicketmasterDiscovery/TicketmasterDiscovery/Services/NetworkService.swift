//
//  NetworkService.swift
//  TicketmasterDiscovery
//
//  Created by Caio Berkley on 23/02/24.
//

import Foundation
import Combine

class NetworkService {
    private let baseURL = "https://app.ticketmaster.com/discovery/v2/"
    private let apiKey = "DW0E98NrxUIfDDtNN7ijruVSm60ryFLX"
    
    func loadEvents(pageNumber: Int, keyword: String) -> AnyPublisher<Network, Error> {
        let route = "events.json?countryCode=US&page=\(pageNumber)&size=20&keyword=\(keyword)&apikey=\(apiKey)"
        return request(route: route, responseType: Network.self)
    }
    
    private func request<T: Decodable>(route: String, responseType: T.Type) -> AnyPublisher<T, Error> {
        guard let url = URL(string: baseURL + route) else {
            return Fail(error: NetworkError.invalidResponse).eraseToAnyPublisher()
        }
        
        var request = URLRequest(url: url)
        request.addValue("application/json", forHTTPHeaderField: "accept")
        
        return URLSession.shared.dataTaskPublisher(for: request)
            .map(\.data)
            .decode(type: T.self, decoder: JSONDecoder())
            .receive(on: DispatchQueue.main)
            .eraseToAnyPublisher()
    }
}
