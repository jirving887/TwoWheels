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
    let laneStadiumLocation: Location
    let searchServiceSpy: SearchServiceSpy
    let sut: ExploreViewModel

    init() {
        laneStadiumLocation = Location(name: "Lane Stadium", latitude: 37.219940, longitude: -80.418055)
        searchServiceSpy = SearchServiceSpy()
        sut = ExploreViewModel(searchDataSource: searchServiceSpy)
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
    func search_shouldCallSearchServiceOnce() async throws {
        let searchText = "Lane Stadium"
        let coordinate = CLLocationCoordinate2D(latitude: 37.219940, longitude: -80.418055)
        let latitudinalMeters = CLLocationDistance(100)
        let longitudinalMeters = CLLocationDistance(100)
        let visibleRegion = MKCoordinateRegion(
            center: coordinate,
            latitudinalMeters: latitudinalMeters,
            longitudinalMeters: longitudinalMeters
        )
        sut.searchText = searchText
        sut.mapPosition = .region(visibleRegion)
        sut.searchText = searchText
        sut.visibleRegion = visibleRegion

        await sut.search()

        try #require(searchServiceSpy.recievedSearchRequests.count == 1)
        #expect(searchServiceSpy.recievedSearchRequests[0].naturalLanguageQuery == searchText)
        #expect(searchServiceSpy.recievedSearchRequests[0].region == visibleRegion)
    }

    @Test
    func search_shouldSetSearchResults() async {
        let dummySearchResult = Location(name: "Burruss Hall", latitude: 37.229000, longitude: -80.423710)
        searchServiceSpy.dummyResults = [dummySearchResult]

        await sut.search()

        #expect(sut.searchResults == [dummySearchResult])
    }

    @Test
    func search_withError_shouldShowAlertAndNotSetSearchResults() async {
        let dummySearchResult = Location(name: "Burruss Hall", latitude: 37.229000, longitude: -80.423710)
        searchServiceSpy.dummyResults = [dummySearchResult]
        searchServiceSpy.error = NSError(domain: "", code: 0, userInfo: nil)
        sut.searchResults = [laneStadiumLocation]

        await sut.search()

        #expect(sut.isShowingSearchErrorAlert)
        #expect(sut.searchResults.isEmpty)
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
