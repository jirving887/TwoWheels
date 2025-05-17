//
//  DirectionsServiceSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 5/17/25.
//

import MapKit
@testable import TwoWheels

class DirectionsServiceSpy: Directing {
    var expectedUserLocation = MKMapItem()
    
    func getDirections(with request: MKDirections.Request) async throws -> MKRoute {
        .init()
    }
    
    func getUserMapItem() async throws -> MKMapItem {
        expectedUserLocation
    }
}
