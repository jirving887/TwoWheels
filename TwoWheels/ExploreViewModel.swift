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
    private let searchCompleter: any SearchCompleting

    var isShowingDetailSheet = false
    var searchResults: [String] = []

    var selectedLocation: MapSelection<MapLocation>? {
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

    init(locationManager: any Locating, searchCompleter: any SearchCompleting) {
        self.locationManager = locationManager
        self.searchCompleter = searchCompleter
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

    private func didUpdateSearchText() {
        searchCompleter.update(queryFragment: searchText)
    }

    private func didUpdateMapPosition() {
        guard let region = mapPosition.region else { return }
        searchCompleter.update(region: region)
    }
}

protocol Locating {
    func requestWhenInUseAuthorization()
}

extension CLLocationManager: Locating {}

protocol SearchCompleting: MKLocalSearchCompleterDelegate {
    func update(region: MKCoordinateRegion)
    func update(queryFragment: String)
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter)
}

class SearchCompleter: NSObject, SearchCompleting {
    func update(region: MKCoordinateRegion) {}

    func update(queryFragment: String) {}

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {}
}
