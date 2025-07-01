//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
import MapKit
import SwiftUI

@Observable
class ExploreViewModel {
    private let dataService: any DataManipulating<Destination>
    private let searchService: MapSearching
    private let geocoder: Geocoding
    private let directionsService: Directing
    
    let completer = MKLocalSearchCompleter()
    var isSearchSheetPresented = false
    var isInfoSheetPresented = false
    var isListSheetPresented = false
    var isDirectionsSheetPresented = false
    var isDirectionsAlertPresented = false
    var destinations: [Destination] = []
    var editingDestination: Destination?
    var tappedLocations: [Destination] = []
    var visibleRegion = MKCoordinateRegion.init()
    var position = MapCameraPosition.userLocation(fallback: .automatic)
    var routeDistance = ""
    var routeTime = ""
    
    var route: MKRoute? {
        didSet {
            updateDistance(with: route?.distance ?? 0)
            updateTime(with: route?.expectedTravelTime ?? 0)
        }
    }
    
    var searchResults: [Destination] = [] {
        didSet {
            searchResultsUpdated()
        }
    }
    
    var searchString: String = "" {
        didSet {
            searchStringUpdated()
        }
    }
    
    var searchCompletions: [MKLocalSearchCompletion] {
        get {
            completer.results
        } set {}
    }
    
    var selectedDestination: Destination? {
        didSet {
            selectedDestinationUpdated()
        }
    }
    
    init(
        dataService: any DataManipulating<Destination>,
        searchService: MapSearching,
        geocoder: Geocoding,
        directionsService: Directing
    ) {
        self.dataService = dataService
        self.searchService = searchService
        self.geocoder = geocoder
        self.directionsService = directionsService
        destinations = dataService.fetch()
    }
    
    func addDestination(_ destination: Destination) {
        dataService.add(destination)
        destinations = dataService.fetch()
    }
    
    func deleteDestination(_ destination: Destination) {
        dataService.remove(destination)
        destinations = dataService.fetch()
    }
    
    func search() async {
        guard !searchString.isEmpty else {
            searchResults = []
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchString
        request.region = visibleRegion
        await search(request)
    }
    
    func search(with completion: MKLocalSearchCompletion) async {
        let request = MKLocalSearch.Request(completion: completion)
        await search(request)
    }
    
    func searchStringUpdated() {
        guard !searchString.isEmpty else {
            searchCompletions = []
            return
        }
        if searchString.count == 1 {
            completer.region = visibleRegion
        }
        completer.queryFragment = searchString
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
        searchCompletions = []
        searchString = ""
    }
    
    func addPin(_ pin: Destination) {
        tappedLocations.append(pin)
        selectedDestination = pin
    }
    
    func removePin(_ pin: Destination) {
        tappedLocations.removeAll { $0 === pin }
        isInfoSheetPresented = false
    }
    
    func selectDestinationFromList(_ destination: Destination) {
        selectedDestination = destination
        isListSheetPresented = false
    }
    
    func showDirections() async {
        guard let destination = selectedDestination?.mapItem else {
            isDirectionsAlertPresented = true
            return
        }
        let request = MKDirections.Request()
        request.source = try? await directionsService.getUserMapItem()
        request.destination = destination
        do {
            route = try await directionsService.getDirections(with: request)
        } catch {
            print("Could not get directions, error: \(error)")
            isDirectionsAlertPresented = true
            return
        }
        isInfoSheetPresented = false
        isDirectionsSheetPresented = true
    }
    
    func updateDistance(with meters: Double) {
        let miles = meters / 1609.34
        routeDistance = String(format: "%.2f mi", miles)
    }
    
    func updateTime(with seconds: Double) {
        let time = Int(seconds)
        let days: Int = time / 86400
        let hours: Int = (time % 86400) / 3600
        let minutes: Int = ((time % 86400) % 3600) / 60
        var result: [String] = []
        if days > 0 { result.append("\(days)d") }
        if hours > 0 { result.append("\(hours)h") }
        if minutes > 0 { result.append("\(minutes)m") }
        routeTime = result.joined(separator: ", ")
    }
    
    private func search(_ request: MKLocalSearch.Request) async {
        do {
            searchResults = try await searchService.search(with: request).compactMap {
                Destination($0)
            }
        } catch {
            searchResults = []
        }
    }
    
    private func searchResultsUpdated() {
        isSearchSheetPresented = false
        if searchResults.count == 1 {
            selectedDestination = searchResults.first
        } else if let first = searchResults.first,
                  let item = first.mapItem {
            position = .item(item)
        }
    }
    
    private func selectedDestinationUpdated() {
        if let selectedDestination,
           isValid(selectedDestination) {
            isInfoSheetPresented = true
            isSearchSheetPresented = false
            withAnimation(.easeInOut) {
                if let item = selectedDestination.mapItem {
                    position = .item(item)
                } else {
                    let region = MKCoordinateRegion(
                        center: selectedDestination.coordinate,
                        latitudinalMeters: 200,
                        longitudinalMeters: 200
                    )
                    position = .region(region)
                }
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
