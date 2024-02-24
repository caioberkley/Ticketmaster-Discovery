//
//  EventCardView.swift
//  TicketmasterDiscovery
//
//  Created by Caio Berkley on 23/02/24.
//

import SwiftUI

struct EventCardView: View {
    let event: EventModel

    var body: some View {
        Group {
            if let unwrappedImage = event.images.first, let unwrappedVenue = event.embedded.venues.first {
                HStack {
                    AsyncImage(url: URL(string: unwrappedImage.url)) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)

                    VStack(alignment: .leading) {
                        Text(event.name)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(event.dates.start.localDate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(unwrappedVenue.name)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(unwrappedVenue.city.name)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 10)
                }
                .padding()
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
        }
    }
}
