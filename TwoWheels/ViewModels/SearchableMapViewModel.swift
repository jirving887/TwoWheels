//
//  SearchableMapViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/16/25.
//

import Foundation
import _MapKit_SwiftUI

@Observable
class SearchableMapViewModel {
    var position = MapCameraPosition.userLocation(fallback: .automatic)
    var visibleRegion = MKCoordinateRegion.init()
    var searchResults = [Destination]()
    var selectedLocation: Destination?
    var isSearchSheetPresented  = false
    var isInfoSheetPresented = false
}
