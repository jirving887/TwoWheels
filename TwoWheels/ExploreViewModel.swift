//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import Foundation
import _MapKit_SwiftUI

@MainActor
@Observable
final class ExploreViewModel {
    private let locationManager: any Locating

    var isShowingDetailSheet = false
    var searchCompletions: [MKLocalSearchCompletion]?
    var searchResults: [MKMapItem] = []

    var selectedLocation: MapSelection<MKMapItem>? {
        didSet {
            didUpdateMapSelection()
        }
    }

    var searchText = "" {
        didSet {
            didUpdateSearchText()
        }
    }

    var mapPosition = MapCameraPosition.userLocation(fallback: .automatic) {
        didSet {
            didUpdateMapPosition()
        }
    }

    init(
        locationManager: any Locating,
    ) {
        self.locationManager = locationManager
        self.locationManager.requestWhenInUseAuthorization()
    }

    func didDismissDetailSheet() {
        selectedLocation = nil
    }

    func recieveCompleter(update: [MKLocalSearchCompletion]) {
        searchCompletions = update
    }

    func search(with completion: MKLocalSearchCompletion) {
        let request = MKLocalSearch.Request(completion: completion)
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

    private func didUpdateSearchText() {
    }

    private func didUpdateMapPosition() {
        guard let region = mapPosition.region else { return }
    }
}

protocol Locating {
    func requestWhenInUseAuthorization()
}

extension CLLocationManager: Locating {}
