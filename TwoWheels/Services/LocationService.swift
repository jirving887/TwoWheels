//
//  LocationService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/24/24.
//



import MapKit
import SwiftUI

struct SearchResult: Identifiable, Hashable {
    let id = UUID()
    let mapItem: MKMapItem
    
    static func == (lhs: SearchResult, rhs: SearchResult) -> Bool {
        lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

@Observable
class LocationService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter
    var completions = [MKLocalSearchCompletion]()
    
    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }
    
    func update(region: MKCoordinateRegion) {
        completer.region = region
    }
    
    func update(queryFragment: String) {
        completer.queryFragment = queryFragment
    }
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        completions = completer.results
    }
    
    func search(with query: String, region: MKCoordinateRegion) async throws -> [SearchResult] {
        let mapKitRequest = MKLocalSearch.Request()
        mapKitRequest.naturalLanguageQuery = query
        mapKitRequest.region = region
        
        return try await search(mapKitRequest)
    }
    
    func search(for completion: MKLocalSearchCompletion, region: MKCoordinateRegion) async throws -> [SearchResult] {
        let mapKitRequest = MKLocalSearch.Request(completion: completion)
        mapKitRequest.region = region
        
        return try await search(mapKitRequest)
    }
    
    func search( _ request: MKLocalSearch.Request) async throws -> [SearchResult] {
        request.resultTypes = [.pointOfInterest, .address]
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        return response.mapItems.compactMap(SearchResult.init(mapItem:))
    }
    
}
