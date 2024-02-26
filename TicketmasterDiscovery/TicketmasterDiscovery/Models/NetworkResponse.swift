//
//  NetworkResponse.swift
//  TicketmasterDiscovery
//
//  Created by Caio Berkley on 23/02/24.
//

import Foundation
import SwiftData

// MARK: - Network Response Model
struct Network: Codable {
    let embedded: NetworkEmbedded

    enum CodingKeys: String, CodingKey {
        case embedded = "_embedded"
    }
}

struct NetworkEmbedded: Codable {
    let events: [EventModel]
}

//MARK: - Event Model
struct EventModel: Codable {
    let name, id, url: String
    let images: [EventImage]
    let dates: EventDate
    let ageRestrictions: AgeRestrictions?
    let embedded: EventEmbedded

    enum CodingKeys: String, CodingKey {
        case name, id, url, images, dates, ageRestrictions
        case embedded = "_embedded"
    }
}

struct EventImage: Codable {
    let url: String
    let width, height: Int
}

struct AgeRestrictions: Codable {
    let legalAgeEnforced: Bool
}

//MARK: - Event Date Model
struct EventDate: Codable {
    let start: StartDate
}

struct StartDate: Codable {
    let localDate: String
}

//MARK: - Venues Model
struct EventEmbedded: Codable {
    let venues: [Venue]
}

struct Venue: Codable {
    let name: String
    let city: VenueCity
    let state: VenueState

    enum CodingKeys: String, CodingKey {
        case name, city, state
    }
}

struct VenueState: Codable {
    let stateCode: String
}

struct VenueCity: Codable {
    let name: String
}
