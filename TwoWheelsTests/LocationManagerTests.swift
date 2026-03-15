//
//  LocationManagerTests.swift
//  TwoWheelsTests
//
//  Created on 3/15/26.
//

import CoreLocation
import Testing
@testable import TwoWheels

struct LocationManagerTests {

    @Test
    func init_shouldHaveNilCurrentLocation() {
        let sut = LocationManager()

        #expect(sut.currentLocation == nil)
    }
}
