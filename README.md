# Ticketmaster Discovery

This app let you search for events, attractions and other events taking place in various cities from United States. 

## Summary

- [Specs](#specs)
- [Installation and Usage](#installation-and-usage)
- [Roadmap](#roadmap)
- [Demonstration Video and Screenshots](#demonstration-video-and-screenshots)

## Specs

The project was developed using SwiftUI, with the Combine framework and SwiftData, and designed with the Model-View-ViewModel (MVVM) architecture. The app has an responsive layout to any supported device (iPhone, iPad and MacOS).

## Installation and Usage

The requirements:

- iOS 17.0 or higher
- macOS 14.0 or higher
- Xcode 15.2 or higher

After downloading or cloning the repository to your Mac, open TicketmasterDiscovery.xcodeproj, and the app should run without any issues.

The default quota is 5000 API calls per day and rate limitation of 5 requests per second. So, if you don't see any events on the home screen, I suggest changing the current API Key in TicketmasterDiscovery/Network/APIService.swift to your personal key (get one [here](https://developer-acct.ticketmaster.com/user/register)). This will help you avoid access denial issues with API requests. After that get more info: [Ticketmaster Discovery API Documentation](https://developer.ticketmaster.com/products-and-docs/apis/discovery-api/v2/)

## Roadmap

- Base solution with SwiftUI and Combine (Done)
- Dependency Injection (Done)
- MVVM Architecture (Done)
- Text search (Done)
- SwiftData (In progress)
- Error Handling (In progress)
- Unit Tests (Done)
- UI Tests (Done)

## Demonstration Video and Screenshots

TBD
