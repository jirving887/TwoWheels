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
    let sut: ExploreViewModel

    init() {
        laneStadiumLocation = Location(name: "Lane Stadium", latitude: 37.219940, longitude: -80.418055)
        sut = ExploreViewModel()
    }

    @Test
    func init_shouldSetInitialValues() {
        #expect(sut.mapPosition == MapCameraPosition.userLocation(fallback: .automatic))
        #expect(sut.mapSelection == nil)
        #expect(sut.selectedLocation == nil)
        #expect(sut.searchText.isEmpty)
    }

    @Test
    func init_shouldNotShowDetailSheet() {
        #expect(!sut.isShowingDetailSheet)
    }

    @Test
    func didUpdateMapSelection_withNil_shouldNotShowDetailSheet() {
        sut.mapSelection = nil

        #expect(!sut.isShowingDetailSheet)
        #expect(sut.selectedLocation == nil)
    }

    @Test
    func didUpdateMapSelection_withLocation_shouldSetSelectedLocation() {
        sut.mapSelection = MapSelection(laneStadiumLocation)

        #expect(sut.isShowingDetailSheet)
        #expect(sut.selectedLocation == laneStadiumLocation)
    }

    @Test
    func didUpdateMapSelection_withNilFeatureAndMapLocation_shouldNotShowDetailSheet() {
        sut.mapSelection = MapSelection(nil)

        #expect(!sut.isShowingDetailSheet)
        #expect(sut.selectedLocation == nil)
    }

    @Test
    func didDismissDetailSheet_shouldDeselectLocation() {
        sut.mapSelection = MapSelection(laneStadiumLocation)

        sut.didDismissDetailSheet()

        #expect(sut.mapSelection == nil)
        #expect(sut.selectedLocation == nil)
    }
}
