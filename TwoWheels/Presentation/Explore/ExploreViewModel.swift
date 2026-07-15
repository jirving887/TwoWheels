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
    private var searchUseCase: any SearchUseCase

    var isShowingDetailSheet = false
    var isShowingSearchErrorAlert = false
    var mapPosition = MapCameraPosition.userLocation(fallback: .automatic)
    var searchText = ""
    var searchResults: [Location] = []
    var visibleRegion: MKCoordinateRegion = MKCoordinateRegion()

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
            return Location(from: feature)
        }
        return nil
    }

    init(searchUseCase: any SearchUseCase) {
        self.searchUseCase = searchUseCase
    }

    func didDismissDetailSheet() {
        mapSelection = nil
    }

    func search() async {
        let query = SearchQuery(
            queryString: searchText,
            latitude: visibleRegion.center.latitude,
            longitude: visibleRegion.center.longitude,
            latitudeDelta: visibleRegion.span.latitudeDelta,
            longitudeDelta: visibleRegion.span.longitudeDelta
        )
        _ = try? await searchUseCase.search(for: query)
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
