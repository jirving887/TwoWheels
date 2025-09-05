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
    private let searchService: any Searching

    let searchCompleter: any SearchCompleting
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
        searchService: any Searching,
        searchCompleter: any SearchCompleting
    ) {
        self.locationManager = locationManager
        self.searchService = searchService
        self.searchCompleter = searchCompleter

        self.searchCompleter.didUpdateCompletions = { [weak self] completions in
            self?.recieveCompleter(update: completions)
        }
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
        Task {
            do {
                searchResults = try await searchService.search(with: request)
            } catch {}
        }
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
