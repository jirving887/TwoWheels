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
    var selectedLocation: Destination? {
        didSet {
            selectedLocationUpdated()        }
    }
    
    var isSearchSheetPresented  = false
    var isInfoSheetPresented = false
    
    func selectedLocationUpdated() {
        if let selectedLocation, let mapItem = selectedLocation.mapItem, mapItem.placemark.coordinate.latitude != -180.0 ||
                mapItem.placemark.coordinate.longitude != -180.0 {
                isInfoSheetPresented = true
                isSearchSheetPresented = false
                position = MapCameraPosition.item(mapItem)
        } else {
            isInfoSheetPresented = false
        }
    }
}
