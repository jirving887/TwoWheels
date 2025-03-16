//
//  MapService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/24/24.
//

import MapKit

@Observable
class MapService: NSObject, MKLocalSearchCompleterDelegate {
    private let completer: MKLocalSearchCompleter
    private let searchProvider: MapSearchable
    var completions = [MKLocalSearchCompletion]()
    
    init(completer: MKLocalSearchCompleter, searchProvider: MapSearchable = MapSearchService()) {
        self.completer = completer
        self.searchProvider = searchProvider
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
    
    func search(for query: String, in region: MKCoordinateRegion) async throws -> [Destination] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = query
        request.region = region
        
        return try await searchProvider.search(with: request).compactMap { item in
            Destination(item)
        }
    }
    
    func search(for completion: MKLocalSearchCompletion, region: MKCoordinateRegion) async throws -> [Destination] {
        let request = MKLocalSearch.Request(completion: completion)
        request.region = region
        
        return try await searchProvider.search(with: request).compactMap { item in
            Destination(item)
        }
    }
    
    static func address(from location: CLLocation) async throws -> String {
        let geocoder = CLGeocoder()
        
        let placemarks = try await geocoder.reverseGeocodeLocation(location)
        let placemark = placemarks.first
        
        return "\(placemark?.subThoroughfare ?? "") \(placemark?.thoroughfare ?? "") \(placemark?.locality ?? ""), \(placemark?.administrativeArea ?? "") \(placemark?.postalCode ?? "") \(placemark?.country ?? "")"
    }
}
