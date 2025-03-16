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
        let invalidLocation = Destination(MKMapItem.init())
        let invalidLocation2 = Destination(MKMapItem(placemark: MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: 0, longitude: 0))))
        sut.isInfoSheetPresented = true
        
        sut.selectedLocation = invalidLocation
        
        #expect(!sut.isInfoSheetPresented)
        
        sut.selectedLocation = invalidLocation2
        
        #expect(!sut.isInfoSheetPresented)
    }
    
    @Test
    func selectedLocationUpdated_withValidDestination_showsLocationInfoAndMovesCamera() {
        let laneStadium = CLLocationCoordinate2D(latitude: 37.219716, longitude: -80.418147)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        let laneStadiumDestination = Destination(laneStadiumItem)
        let sut = SearchableMapViewModel()
        sut.isInfoSheetPresented = false
        
        sut.selectedLocation = laneStadiumDestination
        
        #expect(sut.isInfoSheetPresented)
        #expect(sut.position == MapCameraPosition.item(laneStadiumItem))
    }

    @Test
    func searchResultsUpdated_withEmptyResults_searchSheetIsNotPresented() {
        let sut = SearchableMapViewModel()
        sut.isSearchSheetPresented = true
        
        sut.searchResults = []
        
        #expect(!sut.isSearchSheetPresented)
    }
    
    @Test
    func searchResultsUpdated_withOneResult_setsSelectedLocation() {
        let laneStadium = CLLocationCoordinate2D(latitude: 37.219716, longitude: -80.418147)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        let laneStadiumDestination = Destination(laneStadiumItem)
        let sut = SearchableMapViewModel()
        
        sut.searchResults = [laneStadiumDestination]
        
        #expect(sut.selectedLocation == laneStadiumDestination)
    }
    
    @Test
    func searchResultsUpdated_withMultipleResults_cameraPositionIsFirstReult() {
        let laneStadium = CLLocationCoordinate2D(latitude: 37.219716, longitude: -80.418147)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        let laneStadiumDestination = Destination(laneStadiumItem)

        let burussHall = CLLocationCoordinate2D(latitude: 37.229000, longitude: -80.423710)
        let burrussHallItem = MKMapItem(placemark: MKPlacemark(coordinate: burussHall))
        let burussHallDestination = Destination(burrussHallItem)
        
        let sut = SearchableMapViewModel()
        
        sut.searchResults = [laneStadiumDestination, burussHallDestination]
        
        #expect(sut.position == MapCameraPosition.item(laneStadiumItem))
    }
}
