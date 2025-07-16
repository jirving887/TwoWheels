//
//  DirectionsOverviewViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/16/25.
//

import MapKit
import Testing
@testable import TwoWheels

@MainActor
struct DirectionsOverviewViewModelTests {

    @Test(arguments: [
        (meters: 1610, miles: "1.00 mi"),
        (meters: 3991.173, miles: "2.48 mi"),
        (meters: 4667.1, miles: "2.90 mi")
    ])
    func calculateDistance_withMeters_shouldSetRouteDistance(meters: Double, miles: String) {
        let sut = DirectionsOverviewViewModel()

        #expect(sut.calculateDistance(with: meters) == miles)
    }
}
