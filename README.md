# meowdex
Meowdex is an iOS app developed in SwiftUI to explore and learn about cat breeds, powered by [TheCatAPI](https://thecatapi.com/).

## Table of Contents

- [Features](#problem-description)
- [Tech Stack](#solution)
- [Prerequisites](#prerequisites)
- [Technical Details](#technical-details)
- [Improvements](#improvments)

## Features
- Browse a list of cat breeds with images with infinite scroll.
- View detailed information for each breed, including temperament, origin, and description.
- Favorites system.
- Built entirely with Swift and SwiftUI.
- Offline support.

## Tech Stack
- Swift
- SwiftUI   
- [TheCatAPI](https://thecatapi.com/)
- SwiftData
- [Kingfisher](https://github.com/onevcat/Kingfisher)

## Prerequisites
- iOS device or simulator running iOS 18.0 or later.
- Xcode 16.0 or later.
- TheCatAPI API key (available from [TheCatAPI](https://thecatapi.com/)).

## Technical Details
To run the code you need to create the 'Secrets.xcconfig' file inside the 'Resources' folder with an API_KEY to access the API.

## Improvements
The following improvments could be implemented to elevate the quality of the app:
- Implement TCA architecture
- Implement unit tests to the Store and ViewModels
- Implement integration tests
- Implement E2e tests
- Implement an option to enter a "username" to allow to sync favorites across devices