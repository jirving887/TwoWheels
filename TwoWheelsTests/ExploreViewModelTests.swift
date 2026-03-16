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
        #expect(sut.selectedLocation == nil)
        #expect(sut.searchText.isEmpty)
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
        sut.selectedLocation = MapSelection(laneStadiumLocation)

        #expect(sut.isShowingDetailSheet)
    }

    @Test
    func didUpdateselectedLocation_withNilFeatureAndMapLocation_shouldNotShowDetailSheet() {
        sut.selectedLocation = MapSelection(nil)

        #expect(!sut.isShowingDetailSheet)
    }

    @Test
    func didDismissDetailSheet_shouldDeselectLocation() {
        sut.selectedLocation = MapSelection(laneStadiumLocation)

        sut.didDismissDetailSheet()

        #expect(sut.selectedLocation == nil)
    }
}
