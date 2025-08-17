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
    func init_shouldSetInitialValues() {
        #expect(sut.mapPosition == MapCameraPosition.userLocation(fallback: .automatic))
        #expect(sut.selectedLocation == nil)
    }

    @Test
    func init_shouldNotShowDetailSheet() {
        #expect(!sut.isShowingDetailSheet)
    }

    @Test
    func didUpdateSelectedLocation_withNil_shouldNotShowDetailSheet() {
        sut.selectedLocation = nil

        #expect(!sut.isShowingDetailSheet)
    }

    @Test
    func didUpdateSelectedLocation_withLocation_shouldShowDetailSheet() {
        sut.selectedLocation = MapSelection<MapLocation>(MapLocation())

        #expect(sut.isShowingDetailSheet)
    }

    @Test
    func didUpdateselectedLocation_withNilFeatureAndMapLocation_shouldNotShowDetailSheet() {
        sut.selectedLocation = MapSelection<MapLocation>(nil)

        #expect(!sut.isShowingDetailSheet)
    }

    @Test
    func didDismissDetailSheet_shouldDeselectLocation() {
        sut.selectedLocation = MapSelection<MapLocation>(MapLocation())

        sut.didDismissDetailSheet()

        #expect(sut.selectedLocation == nil)
    }
}
