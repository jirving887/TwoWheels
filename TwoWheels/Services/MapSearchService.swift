//
//  MapSearchService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/25.
//

import MapKit

struct MapSearchService: MapSearching, MapSearchingProtocol {
    func search(_ searchString: String) -> [MKMapItem] {
        [] // TODO: implement
    }
    
    func search(_ completion: MKLocalSearchCompletion) -> [MKMapItem] {
        []
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
