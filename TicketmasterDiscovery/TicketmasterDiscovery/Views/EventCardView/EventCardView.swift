//
//  EventCardView.swift
//  TicketmasterDiscovery
//
//  Created by Caio Berkley on 23/02/24.
//

import SwiftUI

struct EventCardView: View {
    let viewModel: EventViewModel

    var body: some View {
        Group {
            if let unwrappedImage = viewModel.imageURL {
                HStack(spacing: 0) {
                    AsyncImage(url: unwrappedImage) { image in
                        image.resizable()
                    } placeholder: {
                        ProgressView()
                    }
                    .frame(width: 100, height: 100)
                    .cornerRadius(10)
                    .padding(.trailing, 0)
                    VStack(alignment: .leading) {
                        Text(viewModel.name)
                            .font(.headline)
                            .foregroundColor(.black)
                        Text(viewModel.formattedDate)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(viewModel.location)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                        Text(viewModel.venue)
                            .font(.subheadline)
                            .foregroundColor(.gray)
                    }
                    .padding(.leading, 10)
                    Spacer()
                }
                .padding(.top, 0)
                .background(Color.white)
                .cornerRadius(10)
                .shadow(color: .gray, radius: 5, x: 0, y: 5)
            }
        }
    }
}

struct EventCardView_Previews: PreviewProvider {
    static var previews: some View {
        let sampleViewModel = EventViewModel(event: EventModel(name: "Charlotte Hornets vs. Phoenix Suns",
                                                               id: "",
                                                               url: "https://www.ticketmaster.com/charlotte-hornets-vs-phoenix-suns-charlotte-north-carolina-03-15-2024/event/2D005EF1EEFA6495",
                                                               images: [EventImage(url: "https://s1.ticketm.net/dam/a/236/d381735d-e40d-44c2-9055-91cc0038e236_1340151_RECOMENDATION_16_9.jpg", width: 100, height: 56)],
                                                               dates: EventDate(start: StartDate(localDate: "2024-12-05")),
                                                               ageRestrictions: AgeRestrictions(legalAgeEnforced: true),
                                                               embedded: EventEmbedded(venues: [Venue(name: "Place", city: VenueCity(name: "City"), state: VenueState(stateCode: "State"))])))
        return EventCardView(viewModel: sampleViewModel)
    }
}
