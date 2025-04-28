//
//  MockSearchProvider.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 3/16/25.
//

import MapKit
@testable import TwoWheels

struct SpySearchProvider: MapSearchable {
    var mapItems: [MKMapItem] = []
    var placemarks: [CLPlacemark] = []
    var fakeError: Error?
    
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        if let error = fakeError {
            throw error
        }
        
        return mapItems
    }
    
    func address(from location: CLLocation) async throws -> [CLPlacemark] {
        if let error = fakeError {
            throw error
        }
        
        return placemarks
    }
}
