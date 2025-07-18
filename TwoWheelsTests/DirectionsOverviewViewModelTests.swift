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
    func calculateDistance_withMeters_shouldCalculateCorrectDistance(meters: Double, miles: String) {
        let sut = DirectionsOverviewViewModel()

        #expect(sut.calculateDistance(with: meters) == miles)
    }

    @Test(arguments: [
        (seconds: 3600, expectedTime: "1h"),
        (seconds: 217800, expectedTime: "2d, 12h, 30m"),
        (seconds: 1800, expectedTime: "30m"),
        (seconds: 86400, expectedTime: "1d")
    ])
    func calculateTime_withSeconds_shouldCalculateAndFormatCorrectTime(seconds: Double, expectedTime: String) {
        let sut = DirectionsOverviewViewModel()

        #expect(sut.calculateTime(with: seconds) == expectedTime)
    }

    @Test
    func calculateEta_shouldReturnCorrectEta() {
        let sut = DirectionsOverviewViewModel()

        #expect(sut.calculateEta(with: 3600) != "" )
    }
}
