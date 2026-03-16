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

    var selectedLocation: MapSelection<Location>? {
        didSet {
            didUpdateMapSelection()
        }
    }
    var searchText = ""
    var mapPosition = MapCameraPosition.userLocation(fallback: .automatic)

    func didDismissDetailSheet() {
        selectedLocation = nil
    }

    private func didUpdateMapSelection() {
        guard let selection = selectedLocation else {
            isShowingDetailSheet = false
            return
        }

        if selection.feature == nil && selection.value == nil {
            isShowingDetailSheet = false
        } else {
            isShowingDetailSheet = true
        }
    }
}
