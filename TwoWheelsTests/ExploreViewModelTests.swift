//
//  ExploreViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/12/25.
//

import Testing
@testable import TwoWheels

struct ExploreViewModelTests {
    @Test
    func init_shouldCreateLocationManager() {
        let clLocationManagerSpy = CLLocationManagerSpy()
        _ = ExploreViewModel(locationManager: clLocationManagerSpy)

        #expect(clLocationManagerSpy.requestCallCount == 1)
    }
}
