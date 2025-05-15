//
//  MapSearchService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/25.
//

import MapKit

protocol MapSearching {
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem]
}

class SearchService: MapSearching {
    /// Performs a local map search using the specified request and returns matching map items.
    ///
    /// - Parameter request: The search criteria for the map query.
    /// - Returns: An array of `MKMapItem` objects matching the search request.
    /// - Throws: An error if the search operation fails.
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        return response.mapItems
    }
//    
//    func address(from location: CLLocation) async throws -> [CLPlacemark] {
//        try await CLGeocoder().reverseGeocodeLocation(location)
//    }
}
