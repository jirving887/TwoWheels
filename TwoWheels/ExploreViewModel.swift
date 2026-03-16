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
