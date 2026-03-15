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
        sut = ExploreViewModel(
            locationManager: locationManagerSpy
        )
    }

    @Test
    func init_shouldCreateLocationManager() {
        #expect(locationManagerSpy.requestCallCount == 1)
    }

    @Test
    func init_shouldSetInitialValues() {
        #expect(sut.mapPosition == MapCameraPosition.userLocation(fallback: .automatic))
        #expect(sut.selectedLocation == nil)
        #expect(sut.searchText.isEmpty)
        #expect(sut.searchCompletions == nil)
        #expect(sut.searchResults == [])
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
        sut.selectedLocation = MapSelection<MKMapItem>(MKMapItemDummy())

        #expect(sut.isShowingDetailSheet)
    }

    @Test
    func didUpdateselectedLocation_withNilFeatureAndMapLocation_shouldNotShowDetailSheet() {
        sut.selectedLocation = MapSelection<MKMapItem>(nil)

        #expect(!sut.isShowingDetailSheet)
    }

    @Test
    func didDismissDetailSheet_shouldDeselectLocation() {
        sut.selectedLocation = MapSelection<MKMapItem>(MKMapItemDummy())

        sut.didDismissDetailSheet()

        #expect(sut.selectedLocation == nil)
    }

    @Test
    func recieveCompleterUpdate_shouldSetSearchCompletions() {
        sut.recieveCompleter(update: [MKLocalSearchCompletion()])

        #expect(sut.searchCompletions != nil)
    }
}

extension MKCoordinateRegion: @retroactive Equatable {
    static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center == rhs.center && lhs.span == rhs.span
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension MKCoordinateSpan: @retroactive Equatable {
    static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}

nonisolated class MKMapItemDummy: MKMapItem {
    var dummyTitle = ""
}

nonisolated class MKLocalSearchCompletionDummy: MKLocalSearchCompletion {
    var dummyTitle = ""
}
