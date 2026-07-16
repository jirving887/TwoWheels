//
//  ExploreViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/12/25.
//

import ExpectToEventuallyEqual
import _MapKit_SwiftUI
import Testing
@testable import TwoWheels

struct ExploreViewModelTests {
    let laneStadiumLocation: Location
    let spySearchUseCase: SearchUseCaseSpy
    let sut: ExploreViewModel

    init() {
        laneStadiumLocation = Location(name: "Lane Stadium", latitude: 37.219940, longitude: -80.418055)
        spySearchUseCase = SearchUseCaseSpy()
        sut = ExploreViewModel(searchUseCase: spySearchUseCase)
    }

    @Test
    func init_shouldSetInitialValues() {
        #expect(sut.mapPosition == MapCameraPosition.userLocation(fallback: .automatic))
        #expect(sut.mapSelection == nil)
        #expect(sut.selectedLocation == nil)
        #expect(sut.searchText.isEmpty)
        #expect(sut.searchResults.isEmpty)
        #expect(!sut.isShowingSearchErrorAlert)
    }

    @Test
    func init_shouldNotShowDetailSheet() {
        #expect(!sut.isShowingDetailSheet)
    }

    @Test
    func didUpdateMapSelection_withNil_shouldNotShowDetailSheet() {
        sut.mapSelection = nil

        #expect(!sut.isShowingDetailSheet)
    }

    @Test
    func didUpdateMapSelection_withNil_shouldNotSetSelectedLocation() {
        sut.mapSelection = nil

        #expect(sut.selectedLocation == nil)
    }

    @Test
    func didUpdateMapSelection_withLocation_shouldShowDetailSheet() {
        sut.mapSelection = MapSelection(laneStadiumLocation)

        #expect(sut.isShowingDetailSheet)
    }

    @Test
    func didUpdateMapSelection_withLocation_shouldSetSelectedLocation() {
        sut.mapSelection = MapSelection(laneStadiumLocation)

        #expect(sut.selectedLocation == laneStadiumLocation)
    }

    @Test
    func didUpdateMapSelection_withNilFeatureAndLocation_shouldNotShowDetailSheet() {
        sut.mapSelection = MapSelection(nil)

        #expect(!sut.isShowingDetailSheet)
    }

    @Test
    func didUpdateMapSelection_withNilFeatureAndLocation_shouldNotSetSelectedLocation() {
        sut.mapSelection = MapSelection(nil)

        #expect(sut.selectedLocation == nil)
    }

    @Test
    func didDismissDetailSheet_shouldDeselectLocation() {
        sut.mapSelection = MapSelection(laneStadiumLocation)

        sut.didDismissDetailSheet()

        #expect(sut.mapSelection == nil)
        #expect(sut.selectedLocation == nil)
    }

    @Test
    func `search should call search use case with search text and region`() async throws {
        let searchText = "Lane Stadium"
        let coordinate = CLLocationCoordinate2D(latitude: 37.219940, longitude: -80.418055)
        let latitudinalMeters = CLLocationDistance(100)
        let longitudinalMeters = CLLocationDistance(100)
        let span = MKCoordinateSpan(
            latitudeDelta: latitudinalMeters,
            longitudeDelta: longitudinalMeters
        )
        let visibleRegion = MKCoordinateRegion(
            center: coordinate,
            span: span
        )
        sut.searchText = searchText
        sut.visibleRegion = visibleRegion

        sut.search()

        try await expectToEventuallyEqual(actual: { spySearchUseCase.searchedQueries.count }, expected: 1)
        try await expectToEventuallyEqual(actual: {
            if let searchedQuery = spySearchUseCase.searchedQueries.first {
                return searchedQuery.queryString
            }
            return ""
        }, expected: "Lane Stadium")
        try await expectToEventuallyEqual(actual: {
            if let searchedQuery = spySearchUseCase.searchedQueries.first {
                return searchedQuery.latitude
            }
            return 0
        }, expected: 37.219940)
        try await expectToEventuallyEqual(actual: {
            if let searchedQuery = spySearchUseCase.searchedQueries.first {
                return searchedQuery.longitude
            }
            return 0
        }, expected: -80.418055)
        try await expectToEventuallyEqual(actual: {
            if let searchedQuery = spySearchUseCase.searchedQueries.first {
                return searchedQuery.latitudeDelta
            }
            return 0
        }, expected: 100)
        try await expectToEventuallyEqual(actual: {
            if let searchedQuery = spySearchUseCase.searchedQueries.first {
                return searchedQuery.longitudeDelta
            }
            return 0
        }, expected: 100)
    }

    @Test
    func `search with success should update search results`() async throws {
        spySearchUseCase.results = [laneStadiumLocation]

        sut.search()

        try await expectToEventuallyEqual(actual: { sut.searchResults }, expected: [laneStadiumLocation])
    }

    @Test
    func `search with error should empty search results`() async throws {
        spySearchUseCase.shouldThrowError = true
        sut.searchResults = [laneStadiumLocation]

        sut.search()

        try await expectToEventuallyEqual(actual: { sut.searchResults.isEmpty }, expected: true)
    }

    @Test
    func `search with error should show alert`() async throws {
        spySearchUseCase.shouldThrowError = true

        sut.search()

        try await expectToEventuallyEqual(actual: { sut.isShowingSearchErrorAlert }, expected: true)
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
