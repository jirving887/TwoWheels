//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import _MapKit_SwiftUI
import Foundation

@Observable
final class ExploreViewModel {
    var isShowingDetailSheet = false
    var searchCompletions: [MKLocalSearchCompletion]?
    var searchResults: [MKMapItem] = []

    var selectedLocation: MapSelection<MKMapItem>? {
        didSet {
            didUpdateMapSelection()
        }
    }
    var searchText = ""
    var mapPosition = MapCameraPosition.userLocation(fallback: .automatic)

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
}
