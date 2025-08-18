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
    let searchCompleterSpy: SearchCompleterSpy
    let sut: ExploreViewModel

    init() {
        locationManagerSpy = CLLocationManagerSpy()
        searchCompleterSpy = SearchCompleterSpy()
        sut = ExploreViewModel(locationManager: locationManagerSpy, searchCompleter: searchCompleterSpy)
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
        #expect(sut.searchCompleter.didUpdateCompletions != nil)
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

    @Test
    func didUpdateSearchText_shouldUpdateSearchCompleter() {
        sut.searchText = "Lane Stadium"

        #expect(searchCompleterSpy.queryFragment == "Lane Stadium")
    }

    @Test
    func didUpdateMapPosition_shouldUpdateSearchCompleter() {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804),
            latitudinalMeters: 10,
            longitudinalMeters: 10
        )

        sut.mapPosition = MapCameraPosition.region(region)

        #expect(searchCompleterSpy.region == region)
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
