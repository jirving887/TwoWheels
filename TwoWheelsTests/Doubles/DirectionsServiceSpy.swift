//
//  DirectionsServiceSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 5/17/25.
//

import MapKit
@testable import TwoWheels

class DirectionsServiceSpy: Directing {
    var directionsError: (any Error)?
    var locationError: (any Error)?
    var errorCount = 0
    var expectedRoute = MKRoute()
    var expectedUserLocation = MKMapItem()

    func getDirections(with request: MKDirections.Request) async throws -> MKRoute? {
        if let directionsError {
            errorCount += 1
            throw directionsError
        }
        return expectedRoute
    }

    func getUserMapItem() async throws -> MKMapItem? {
        if let locationError {
            errorCount += 1
            throw locationError
        }
        return expectedUserLocation
    }
}
