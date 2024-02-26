# Ticketmaster Discovery

This app lets you search for events, attractions, and other events in various cities in the United States. 

## Summary

- [Specs](#specs)
- [Installation and Usage](#installation-and-usage)
- [Roadmap](#roadmap)
- [Demonstration Video and Screenshots](#demonstration-video-and-screenshots)

## Specs

The project was developed using SwiftUI, with the Combine framework and SwiftData, and designed with the Model-View-ViewModel (MVVM) architecture. The app has a responsive layout for any supported device (iPhone, iPad, and MacOS).

## Installation and Usage

The requirements:

- iOS 17.0 or higher
- macOS 14.0 or higher
- Xcode 15.2 or higher

After downloading or cloning the repository to your Mac, open TicketmasterDiscovery.xcodeproj, and the app should run without issues.

The default quota is 5000 API calls per day and a rate limitation of 5 requests per second. So, if you don't see any events on the home screen, I suggest changing the current API Key in TicketmasterDiscovery/Network/APIService.swift to your key (get one [here](https://developer-acct.ticketmaster.com/user/register)). This will help you avoid access denial issues with API requests. After that get more info: [Ticketmaster Discovery API Documentation](https://developer.ticketmaster.com/products-and-docs/apis/discovery-api/v2/)

## Roadmap

- Base solution with SwiftUI and Combine (Done)
- Dependency Injection (Done)
- MVVM Architecture (Done)
- Error Handling (Done)
- Text search (Done)
- Unit Tests (Done)
- UI Tests (Done)
- SwiftData (TBD)

## Demonstration Video and Screenshots

<img src="https://github.com/caioberkley/Ticketmaster-Discovery/assets/32444538/e0491b7b-4748-4a96-b71c-3e171ace01db" width="30%" height="30%">
<img src="https://github.com/caioberkley/Ticketmaster-Discovery/assets/32444538/275a8ea2-a251-4ca5-8f32-bb2bfa1528e0" width="30%" height="30%">
<img src="https://github.com/caioberkley/Ticketmaster-Discovery/assets/32444538/424622eb-a24a-4d53-97af-76fc9137e84c" width="30%" height="30%">
<img src="https://github.com/caioberkley/Ticketmaster-Discovery/assets/32444538/508fbd0b-fbd8-4337-b254-034e5ca82d61" width="30%" height="30%">
<img src="https://github.com/caioberkley/Ticketmaster-Discovery/assets/32444538/e67483d6-378f-4019-9de8-f8c3b86e13ab" width="30%" height="30%">
<img src="https://github.com/caioberkley/Ticketmaster-Discovery/assets/32444538/41597bcc-a511-4241-9e84-6d6f6ec9c723" width="30%" height="30%">

[Launchscreen Animation](https://github.com/caioberkley/Ticketmaster-Discovery/assets/32444538/66727bf2-c33f-49f8-a2e8-d26d01068ee8)

[App Flow](https://github.com/caioberkley/Ticketmaster-Discovery/assets/32444538/6208e18e-087d-45ab-9317-f99a73fa46e3)
