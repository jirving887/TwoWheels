//
//  ExploreViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/12/25.
//

import Testing
@testable import TwoWheels

struct ExploreViewModelTests {
    let locationManagerSpy: CLLocationManagerSpy
    let sut: ExploreViewModel

    init() {
        locationManagerSpy = CLLocationManagerSpy()
        sut = ExploreViewModel(locationManager: locationManagerSpy)
    }

    @Test
    func init_shouldCreateLocationManager() {
        #expect(locationManagerSpy.requestCallCount == 1)
    }

        #expect(clLocationManagerSpy.requestCallCount == 1)
    }
}
