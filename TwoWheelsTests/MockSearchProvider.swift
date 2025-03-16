//
//  MockSearchProvider.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 3/16/25.
//

import MapKit
@testable import TwoWheels

struct MockSearchProvider: MapSearchable {
    var mockMapItems: [MKMapItem] = []
    var mockPlacemarks: [CLPlacemark] = []
    var mockError: Error?
    
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        if let error = mockError {
            throw error
        }
        
        return mockMapItems
    }
    
    func address(from location: CLLocation) async throws -> [CLPlacemark] {
        if let error = mockError {
            throw error
        }
        
        return mockPlacemarks
    }
}
