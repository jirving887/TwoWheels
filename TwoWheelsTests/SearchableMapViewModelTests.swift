//
//  SearchableMapViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 1/16/25.
//

import MapKit
import SwiftUI
import Testing
@testable import TwoWheels

struct SearchableMapViewModelTests {

    @Test
    func selectedLocationUpdated_isNil_infoSheetIsntPresented() {
        let sut = SearchableMapViewModel()
        sut.isInfoSheetPresented = true
        
        sut.selectedLocation = nil
        
        #expect(!sut.isInfoSheetPresented)
    }
    
    @Test
    func selectedLocationUpdated_withEmptyDestination_infoSheetIsNotPresented() {
        let sut = SearchableMapViewModel()
        let loc = Destination(MKMapItem.init())
        sut.isInfoSheetPresented = true
        
        sut.selectedLocation = loc
        
        #expect(!sut.isInfoSheetPresented)
    }
    
    @Test
    func selectedLocationUpdated_withValidDestination_showsLocationInfoAndMovesCamera() {
        let laneStadium = CLLocationCoordinate2D(latitude: 37.219716, longitude: -80.418147)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        let loc = Destination(laneStadiumItem)
        let sut = SearchableMapViewModel()
        sut.isSearchSheetPresented = true
        sut.isInfoSheetPresented = false
        
        sut.selectedLocation = loc
        
        #expect(sut.isInfoSheetPresented)
        #expect(!sut.isSearchSheetPresented)
        #expect(sut.position == MapCameraPosition.item(laneStadiumItem))
    }
}
