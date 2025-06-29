//
//  DirectionsServiceSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 5/17/25.
//

import MapKit
@testable import TwoWheels

class DirectionsServiceSpy: Directing {
    var error: Error?
    var errorCount = 0
    var expectedRoute = MKRoute()
    var expectedUserLocation = MKMapItem()
    
    func getDirections(with request: MKDirections.Request) async throws -> MKRoute {
        if let error {
            errorCount += 1
            throw error
        }
        return expectedRoute
    }
    
    func getUserMapItem() async throws -> MKMapItem {
        expectedUserLocation
    }
}
