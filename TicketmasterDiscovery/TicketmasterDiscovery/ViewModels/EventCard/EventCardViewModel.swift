//
//  EventCardViewModel.swift
//  TicketmasterDiscovery
//
//  Created by Caio Berkley on 25/02/24.
//

import Foundation

class EventViewModel {
    let event: EventModel
    let unwrappedVenue: Venue?

    init(event: EventModel) {
        self.event = event
        self.unwrappedVenue = event.embedded.venues.first
    }

    var name: String {
        event.name
    }

    var imageURL: URL? {
        event.images.first.flatMap { URL(string: $0.url) }
    }

    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        if let date = formatter.date(from: event.dates.start.localDate) {
            formatter.dateFormat = "MMM dd, yyyy"
            return formatter.string(from: date)
        } else {
            return ""
        }
    }

    var location: String {
        unwrappedVenue?.name ?? ""
    }

    var venue: String {
        if let city = unwrappedVenue?.city.name, let stateCode = unwrappedVenue?.state.stateCode {
            return "\(city), \(stateCode)"
        } else {
            return ""
        }
    }
}
