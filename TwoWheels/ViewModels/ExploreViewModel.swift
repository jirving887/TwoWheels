//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
@preconcurrency import MapKit
import SwiftUI

@Observable
@MainActor
class ExploreViewModel {
    private let dataService: any DataManipulating<Destination>
    private let geocoder: any Geocoding
    private let directionsService: any Directing

    var isSearchSheetPresented = false
    var isInfoSheetPresented = false
    var isListSheetPresented = false
    var isDirectionsSheetPresented = false
    var isDirectionsAlertPresented = false
    var isNavigationAlertPresented = false
    var destinations: [Destination] = []
    var editingDestination: Destination?
    var tappedLocations: [Destination] = []
    var visibleRegion = MKCoordinateRegion.init()
    var position = MapCameraPosition.userLocation(fallback: .automatic)

    var searchResults: [Destination] = []
    
    var selectedDestination: Destination? {
        didSet {
            print("UPDATING SELECTED DESTINATION")
            selectedDestinationUpdated()
        }
    }
    
    init(
        dataService: any DataManipulating<Destination>,
        geocoder: any Geocoding,
        directionsService: any Directing
    ) {
        self.dataService = dataService
        self.geocoder = geocoder
        self.directionsService = directionsService
        refreshDestinations()
    }
    
    func addDestination(_ destination: Destination) {
        dataService.add(destination)
        refreshDestinations()
    }
    
    func deleteDestination(_ destination: Destination) {
        dataService.remove(destination)
        refreshDestinations()
    }
    
    func addressFromLocation(_ location: CLLocation) async -> String {
        do {
            let placemarks =  try await geocoder.reverseGeocodeLocation(location)
            let placemark = placemarks.first
            return 
                """
                \(placemark?.subThoroughfare ?? "") \
                \(placemark?.thoroughfare ?? "") \
                \(placemark?.locality ?? ""), \
                \(placemark?.administrativeArea ?? "") \
                \(placemark?.postalCode ?? "") \
                \(placemark?.country ?? "")
                """
        } catch {
            return "Unable to determine address"
        }
    }
    
    func reset() {
        searchResults = []
        selectedDestination = nil
    }
    
    func addPin(_ pin: Destination) {
        tappedLocations.append(pin)
        selectedDestination = pin
    }

    func isPin(_ pin: Destination) -> Bool {
        tappedLocations.contains(pin)
    }

    func removePin(_ pin: Destination) {
        tappedLocations.removeAll { $0 == pin }
        isInfoSheetPresented = false
    }
    
    func selectDestinationFromList(_ destination: Destination) {
        selectedDestination = destination
        isListSheetPresented = false
    }
    
    func startNavigation() {
        isNavigationAlertPresented = true
    }
    
    func searchResultsUpdated(_ results: [Destination]) {
        searchResults = results
        isSearchSheetPresented = false
        if searchResults.count == 1 {
            selectedDestination = searchResults.first
        } else if let first = searchResults.first {
            selectedDestination = nil
            let region = MKCoordinateRegion(
                center: first.coordinate,
                latitudinalMeters: 10000,
                longitudinalMeters: 10000
            )
            position = .region(region)
        }
    }

    func isSaved(_ destination: Destination) -> Bool {
        destinations.contains(destination)
    }

    func refreshDestinations() {
        destinations = dataService.fetch()
    }

    private func selectedDestinationUpdated() {
        isInfoSheetPresented = false
        if let selectedDestination,
           isValid(selectedDestination) {
            Task {
                let location = CLLocation(
                    latitude: selectedDestination.coordinate.latitude,
                    longitude: selectedDestination.coordinate.longitude
                )
                selectedDestination.address = await addressFromLocation(location)
            }
            isInfoSheetPresented = true
            isSearchSheetPresented = false
            withAnimation(.easeInOut) {
                let placemark = MKPlacemark(coordinate: selectedDestination.coordinate)
                let item = MKMapItem(placemark: placemark)
                position = .item(item)
            }
        } else {
            isInfoSheetPresented = false
        }
    }
    
    private func isValid(_ destination: Destination) -> Bool {
        destination.latitude != 0 &&
        destination.longitude != 0
    }
}
