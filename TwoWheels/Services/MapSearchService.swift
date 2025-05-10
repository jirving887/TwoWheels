//
//  MapSearchService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/25.
//

import MapKit

class MapSearchService: MapSearching, MapSearchingProtocol {
    func search(for searchString: String, in region: MKCoordinateRegion) -> [MKMapItem] {
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchString
        request.region = region
        return search(request)
    }
    
    func search(with completion: MKLocalSearchCompletion) -> [MKMapItem] {
        let request = MKLocalSearch.Request(completion: completion)
        return search(request)
    }
    
    private func search(_ request: MKLocalSearch.Request) -> [MKMapItem] {
        var results: [MKMapItem] = []
        let search = MKLocalSearch(request: request)
        
        search.start { response, error in
            guard let response = response else {
                print("Search failed with error: \(String(describing: error))")
                return
            }
            results = response.mapItems
        }
        return results
    }
    
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        return response.mapItems
    }
    
    func address(from location: CLLocation) async throws -> [CLPlacemark] {
        try await CLGeocoder().reverseGeocodeLocation(location)
    }
}
