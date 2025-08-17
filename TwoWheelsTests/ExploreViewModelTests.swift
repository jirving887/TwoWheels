//
//  ExploreViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/12/25.
//

import _MapKit_SwiftUI
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

    @Test
    func init_shouldSetMapCameraPosition() {
        #expect(sut.mapPosition == MapCameraPosition.userLocation(fallback: .automatic))
    }

    @Test
    func init_shouldSetSelectionNil() {
        #expect(sut.selectedLocation == nil)
    }
}
