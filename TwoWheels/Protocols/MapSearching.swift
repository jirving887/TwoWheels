//
//  MapSearching.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/25.
//

import MapKit

protocol MapSearching {
    
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem]
    
    func address(from location: CLLocation) async throws -> [CLPlacemark]
}

// MARK: Refactoring

protocol MapSearchingProtocol {
    func search(_ searchString: String) -> [MKMapItem]
    func search(_ completion: MKLocalSearchCompletion) -> [MKMapItem]
}
