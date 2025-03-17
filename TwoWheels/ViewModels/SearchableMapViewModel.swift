//
//  SearchableMapViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/16/25.
//

import MapKit
import SwiftUI

@Observable
class SearchableMapViewModel: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter
    private let searchProvider: MapSearchable
    
    var completions = [MKLocalSearchCompletion]()
    var isSearchSheetPresented = false
    var isInfoSheetPresented = false
    var position = MapCameraPosition.userLocation(fallback: .automatic)
    var visibleRegion = MKCoordinateRegion.init()
    
    var searchResults = [Destination]() {
        didSet {
            searchResultsUpdated()
        }
    }
    
    var selectedLocation: Destination? {
        didSet {
            selectedLocationUpdated()
        }
    }
    
    init(completer: MKLocalSearchCompleter = MKLocalSearchCompleter(),
         searchProvider: MapSearchable = MapSearchService()) {
        self.completer = completer
        self.searchProvider = searchProvider
        super.init()
        self.completer.delegate = self
    }
    
    func address(from location: CLLocation) async throws -> String {
        let placemarks = try await searchProvider.address(from: location)
        let placemark = placemarks.first
        
        return "\(placemark?.subThoroughfare ?? "") \(placemark?.thoroughfare ?? "") \(placemark?.locality ?? ""), \(placemark?.administrativeArea ?? "") \(placemark?.postalCode ?? "") \(placemark?.country ?? "")"
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results
    }
    
    func reset() {
        searchResults = []
        selectedLocation = nil
        completions = []
    }
    
    func search(for query: String) async {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = visibleRegion
        
        do {
            searchResults = try await searchProvider.search(with: request).compactMap { item in
                Destination(item)
            }
        } catch {
            print(error)
            searchResults = []
        }
    }
    
    func search(for completion: MKLocalSearchCompletion) async {
        let request = MKLocalSearch.Request(completion: completion)
        request.region = visibleRegion
        
        do {
            searchResults = try await searchProvider.search(with: request).compactMap { item in
                Destination(item)
            }
        } catch {
            print(error)
            searchResults = []
        }
    }
    
    func selectedLocationUpdated() {
        if let selectedLocation,
           let mapItem = selectedLocation.mapItem,
           mapItem.placemark.coordinate.latitude != -180.0,
           mapItem.placemark.coordinate.longitude != -180.0,
           mapItem.placemark.coordinate.latitude != 0,
           mapItem.placemark.coordinate.longitude != 0 {
            isInfoSheetPresented = true
            isSearchSheetPresented = false
            position = MapCameraPosition.item(mapItem)
        } else {
            isInfoSheetPresented = false
        }
    }
    
    func searchResultsUpdated() {
        isSearchSheetPresented = false
        if searchResults.count == 1 {
            selectedLocation = searchResults.first
        } else if let first = searchResults.first, let item = first.mapItem {
            position = MapCameraPosition.item(item)
        }
    }
    
    func update(queryFragment: String) {
        completer.queryFragment = queryFragment
    }
    
    func update(region: MKCoordinateRegion) {
        completer.region = region
    }
}
