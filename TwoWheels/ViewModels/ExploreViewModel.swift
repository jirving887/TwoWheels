//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
import _MapKit_SwiftUI

@Observable
class ExploreViewModel {
    private let dataService: any DataManupilating<Destination>
    private let searchService: MapSearching
    private let geocoder: Geocoding
    
    let completer = MKLocalSearchCompleter()
    var isSearchSheetPresented = false
    var isInfoSheetPresented = false
    var isEditSheetPresented = false
    var destinations: [Destination] = []
    var searchResults: [Destination] = []
    var selectedDestination: Destination?
    var selectedTab: TabSelection = .map
    var visibleRegion = MKCoordinateRegion.init()
    var position = MapCameraPosition.userLocation(fallback: .automatic)
    
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
    
    init(dataService: any DataManupilating<Destination>, searchService: MapSearching, geocoder: Geocoding) {
        self.dataService = dataService
        self.searchService = searchService
        self.geocoder = geocoder
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
    
    private func search(_ request: MKLocalSearch.Request) async {
        do {
            searchResults = try await searchService.search(with: request).compactMap {
                Destination($0)
            }
        } catch {
            searchResults = []
        }
    }
}
