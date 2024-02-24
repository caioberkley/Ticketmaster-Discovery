//
//  NetworkError.swift
//  TicketmasterDiscovery
//
//  Created by Caio Berkley on 23/02/24.
//

import Foundation

enum NetworkError: Error {
    case invalidResponse
    case apiError(String)
    case decodingError(Error)
    case other(Error)
}
