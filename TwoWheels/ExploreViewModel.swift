//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import Foundation
import _MapKit_SwiftUI

@Observable
final class ExploreViewModel {
    private let locationManager: any Locating

    var mapPosition = MapCameraPosition.userLocation(fallback: .automatic)
    var isShowingDetailSheet = false
    var searchText = ""
    var searchResults: [String] = []

    var selectedLocation: MapSelection<MapLocation>? {
        didSet {
            didUpdateMapSelection()
        }
    }

    init(locationManager: any Locating) {
        self.locationManager = locationManager
        self.locationManager.requestWhenInUseAuthorization()
    }

    func didDismissDetailSheet() {
        selectedLocation = nil
    }

    private func didUpdateMapSelection() {
        guard let newLocation = selectedLocation else {
            isShowingDetailSheet = false
            return
        }

        if newLocation.feature == nil && newLocation.value == nil {
            isShowingDetailSheet = false
        } else {
            isShowingDetailSheet = true
        }
    }
}

protocol Locating {
    func requestWhenInUseAuthorization()
}

extension CLLocationManager: Locating {}
