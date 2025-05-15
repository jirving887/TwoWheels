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
    private let dataService: any DataManupilating<Destination>
    private let searchService: MapSearching
    private let geocoder: Geocoding
    
    let completer = MKLocalSearchCompleter()
    var isSearchSheetPresented = false
    var isInfoSheetPresented = false
    var destinations: [Destination] = []
    var editingDestination: Destination?
    var tappedLocations: [Destination] = []
    var selectedTab: TabSelection = .map
    var visibleRegion = MKCoordinateRegion.init()
    var position = MapCameraPosition.userLocation(fallback: .automatic)
    
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
    
    init(dataService: any DataManupilating<Destination>, searchService: MapSearching, geocoder: Geocoding) {
        self.dataService = dataService
        self.searchService = searchService
        self.geocoder = geocoder
        destinations = dataService.fetch()
    }
    
    /// Adds a new destination and refreshes the list of destinations.
    func addDestination(_ destination: Destination) {
        dataService.add(destination)
        destinations = dataService.fetch()
    }
    
    /// Deletes the specified destination and refreshes the destinations list.
    ///
    /// - Parameter destination: The destination to be removed.
    func deleteDestination(_ destination: Destination) {
        dataService.remove(destination)
        destinations = dataService.fetch()
    }
    
    /// Performs a map search using the current search string and visible region.
    ///
    /// Clears search results if the search string is empty; otherwise, initiates an asynchronous search with the specified parameters.
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
    
    /// Performs a map search using the specified search completion and updates search results asynchronously.
    ///
    /// - Parameter completion: The search completion to use for generating the search request.
    func search(with completion: MKLocalSearchCompletion) async {
        let request = MKLocalSearch.Request(completion: completion)
        await search(request)
    }
    
    /// Updates search completions based on the current search string.
    ///
    /// Clears completions if the search string is empty. Sets the search completer's region when the string length is one, and updates the completer's query fragment to match the search string.
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
    
    /// Asynchronously retrieves a formatted address string for the given location using reverse geocoding.
    ///
    /// If the address cannot be determined, returns a default error message.
    ///
    /// - Parameter location: The geographic location to reverse geocode.
    /// - Returns: A formatted address string, or "Unable to determine address" if the lookup fails.
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
    
    /// Clears search results, selected destination, search completions, and the search string, resetting the search-related state.
    func reset() {
        searchResults = []
        selectedDestination = nil
        searchCompletions = []
        searchString = ""
    }
    
    /// Adds a destination as a pin to the map and sets it as the selected destination.
    ///
    /// - Parameter pin: The destination to add as a pin.
    func addPin(_ pin: Destination) {
        tappedLocations.append(pin)
        selectedDestination = pin
    }
    
    /// Removes a tapped location pin from the map and hides the info sheet.
    ///
    /// - Parameter pin: The destination pin to remove from the tapped locations.
    func removePin(_ pin: Destination) {
        tappedLocations.removeAll { $0 === pin }
        isInfoSheetPresented = false
    }
    
    /// Performs an asynchronous map search using the provided request and updates search results.
    ///
    /// Executes the search via the search service, mapping results to `Destination` objects. If the search fails, clears the search results.
    ///
    /// - Parameter request: The map search request to execute.
    private func search(_ request: MKLocalSearch.Request) async {
        do {
            searchResults = try await searchService.search(with: request).compactMap {
                Destination($0)
            }
        } catch {
            searchResults = []
        }
    }
    
    /// Updates UI state based on the current search results.
    ///
    /// Hides the search sheet. If there is exactly one search result, selects it as the destination; otherwise, updates the map position to the first result's map item.
    private func searchResultsUpdated() {
        isSearchSheetPresented = false
        if searchResults.count == 1 {
            selectedDestination = searchResults.first
        } else if let first = searchResults.first,
                  let item = first.mapItem {
            position = .item(item)
        }
    }
    
    /// Updates the UI and map position based on the currently selected destination.
    ///
    /// Presents the info sheet and animates the map camera to the selected destination if it is valid. If the destination has an associated map item, the camera focuses on it; otherwise, it centers the map on the destination's coordinates. Hides the info sheet if the selected destination is invalid.
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
    
    /// Determines whether a destination has valid, non-zero latitude and longitude coordinates.
    ///
    /// - Parameter destination: The destination to validate.
    /// - Returns: `true` if both latitude and longitude are non-zero; otherwise, `false`.
    private func isValid(_ destination: Destination) -> Bool {
        destination.latitude != 0 &&
        destination.longitude != 0
    }
}
