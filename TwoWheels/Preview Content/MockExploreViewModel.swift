//
//  MockExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/6/26.
//

import Foundation
import _MapKit_SwiftUI

@Observable
final class MockExploreViewModel: ExploreViewModelProtocol {
    var mapPosition: MapCameraPosition
    var mapSelection: MapSelection<Location>?
    var visibleRegion: MKCoordinateRegion
    var searchText: String
    var selectedLocation: Location?
    var isShowingDetailSheet: Bool

    init() {
        self.mapPosition = MapCameraPosition.userLocation(fallback: .automatic)
        self.mapSelection = nil
        self.visibleRegion = MKCoordinateRegion()
        self.searchText = ""
        self.selectedLocation = nil
        self.isShowingDetailSheet = false
    }

    func search() {
        print("search")
    }

    func didDismissDetailSheet() {
        print("Dismissed detail sheet")
    }
}
