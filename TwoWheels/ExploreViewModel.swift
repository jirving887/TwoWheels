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

    var mapSelection: MapSelection<Location>? {
        didSet {
            didUpdateMapSelection()
        }
    }

    var selectedLocation: Location? {
        guard let mapSelection else { return nil }
        if let value = mapSelection.value {
            return value
        } else if let feature = mapSelection.feature {
            return Location(feature)
        }
        return nil
    }

    var searchText = ""
    var mapPosition = MapCameraPosition.userLocation(fallback: .automatic)

    func didDismissDetailSheet() {
        mapSelection = nil
    }

    private func didUpdateMapSelection() {
        guard let selection = mapSelection else {
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
