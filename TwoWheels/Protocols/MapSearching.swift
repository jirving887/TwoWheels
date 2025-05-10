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
    func search(for searchString: String, in region: MKCoordinateRegion) -> [MKMapItem]
    func search(with completion: MKLocalSearchCompletion) -> [MKMapItem]
}
