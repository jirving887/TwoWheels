//
//  MapSearchService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/25.
//

import MapKit

class MapSearchService: NSObject, MapSearching, MapSearchingProtocol {
    func search(for searchString: String, in region: MKCoordinateRegion) -> [MKMapItem] {
        [] // TODO: implement
    }
    
    func search(with completion: MKLocalSearchCompletion, in region: MKCoordinateRegion) -> [MKMapItem] {
        []
    }
    
    func update(region: MKCoordinateRegion) {}
    
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        let search = MKLocalSearch(request: request)
        let response = try await search.start()
        
        return response.mapItems
    }
    
    func address(from location: CLLocation) async throws -> [CLPlacemark] {
        try await CLGeocoder().reverseGeocodeLocation(location)
    }
}
