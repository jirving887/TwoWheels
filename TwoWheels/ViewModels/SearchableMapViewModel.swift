//
//  SearchableMapViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/16/25.
//

import MapKit
import SwiftUI

@Observable
class SearchableMapViewModel {
    var position = MapCameraPosition.userLocation(fallback: .automatic)
    var visibleRegion = MKCoordinateRegion.init()
    
    var searchResults = [Destination]() {
        didSet {
            searchResultsUpdated()
        }
    }
    
    var selectedLocation: Destination? {
        didSet {
            selectedLocationUpdated()        }
    }
    
    var isSearchSheetPresented  = false
    var isInfoSheetPresented = false
    
    func selectedLocationUpdated() {
        if let selectedLocation,
           let mapItem = selectedLocation.mapItem,
           mapItem.placemark.coordinate.latitude != -180.0,
           mapItem.placemark.coordinate.longitude != -180.0,
           mapItem.placemark.coordinate.latitude != 0,
           mapItem.placemark.coordinate.longitude != 0 {
                isInfoSheetPresented = true
                position = MapCameraPosition.item(mapItem)
        } else {
            isInfoSheetPresented = false
        }
    }
    
    func searchResultsUpdated() {
        isSearchSheetPresented = false
        if searchResults.count == 1 {
            selectedLocation = searchResults.first
        } else if let first = searchResults.first, let item = first.mapItem {
            position = MapCameraPosition.item(item)
        }
    }
}
