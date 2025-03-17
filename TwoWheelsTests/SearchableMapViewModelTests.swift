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

final class SearchableMapViewModelTests {

    var laneStadiumLatitude: CLLocationDegrees
    var laneStadiumLongitude: CLLocationDegrees
    
    init() {
        laneStadiumLatitude = 37.22001
        laneStadiumLongitude = -80.41804
    }
    
    deinit {
        laneStadiumLatitude = 0
        laneStadiumLongitude = 0
    }
    
    @Test
    func onInit_shouldSetCompleterDelegate() {
        let completer = MKLocalSearchCompleter()
        
        let sut = SearchableMapViewModel(completer: completer)
        
        #expect(completer.delegate === sut)
    }
    
    @Test
    func address_withLocation_shouldReturnStringAddress() async throws {
        let laneStadiumLocation = CLLocation(latitude: laneStadiumLatitude, longitude: laneStadiumLongitude)
        let laneStadiumLocation2D = CLLocationCoordinate2D(latitude: laneStadiumLatitude, longitude: laneStadiumLongitude)
        let laneStadiumAddressDictionary: [String : Any] = [
            "thoroughfare": "Beamer Way",
            "subThoroughfare": "185",
            "locality": "Blacksburg",
            "state": "VA",
            "address": "185 Beamer Way Blacksburg, VA",
            "postalCode": "24061",
            "country": "United States"
        ]
        let laneStadiumPlacemark = CLPlacemark(placemark: MKPlacemark(coordinate: laneStadiumLocation2D, addressDictionary: laneStadiumAddressDictionary))
        
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockPlacemarks: [laneStadiumPlacemark])
        let sut = SearchableMapViewModel(completer: completer, searchProvider: mockSearchProvider)
        
        let address = await sut.address(from: laneStadiumLocation)
        
        #expect("185 Beamer Way Blacksburg, VA 24061 United States".contains(address.trimmingCharacters(in: .whitespaces)))
    }
    
    @Test
    func address_withLocationAndErrors_shouldReturnMessage() async {
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockError: NSError(domain: "Test Error", code: 1, userInfo: nil))
        let sut = SearchableMapViewModel(completer: completer, searchProvider: mockSearchProvider)
        
        let address = await sut.address(from: CLLocation())
        
        #expect(address == "No address available.")
    }
    
    @Test
    func reset_shouldClearSearchResultsAndMakeSelectedLocationNil() {
        let laneStadium = CLLocationCoordinate2D(latitude: laneStadiumLatitude, longitude: laneStadiumLongitude)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        let laneStadiumDestination = Destination(laneStadiumItem)

        let burussHall = CLLocationCoordinate2D(latitude: 37.229000, longitude: -80.423710)
        let burrussHallItem = MKMapItem(placemark: MKPlacemark(coordinate: burussHall))
        let burussHallDestination = Destination(burrussHallItem)
        
        let sut = SearchableMapViewModel()
        
        sut.searchResults = [laneStadiumDestination, burussHallDestination]
        sut.selectedLocation = laneStadiumDestination
        
        sut.reset()
        
        #expect(sut.searchResults.isEmpty)
        #expect(sut.selectedLocation == nil)
        #expect(sut.completions.isEmpty)
    }
    
    @Test
    func selectedLocationUpdated_withNil_shouldNotPresentInfoSheet() {
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
    func selectedLocationUpdated_withValidDestination_shouldShowLocationInfoAndMovesCamera() {
        let laneStadium = CLLocationCoordinate2D(latitude: laneStadiumLatitude, longitude: laneStadiumLongitude)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        let laneStadiumDestination = Destination(laneStadiumItem)
        let sut = SearchableMapViewModel()
        sut.isInfoSheetPresented = false
        sut.isSearchSheetPresented = true
        
        sut.selectedLocation = laneStadiumDestination
        
        #expect(sut.isInfoSheetPresented)
        #expect(!sut.isSearchSheetPresented)
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
        let laneStadium = CLLocationCoordinate2D(latitude: laneStadiumLatitude, longitude: laneStadiumLongitude)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        let laneStadiumDestination = Destination(laneStadiumItem)
        let sut = SearchableMapViewModel()
        
        sut.searchResults = [laneStadiumDestination]
        
        #expect(sut.selectedLocation == laneStadiumDestination)
    }
    
    @Test
    func searchResultsUpdated_withMultipleResults_cameraPositionIsFirstReult() {
        let laneStadium = CLLocationCoordinate2D(latitude: laneStadiumLatitude, longitude: laneStadiumLongitude)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        let laneStadiumDestination = Destination(laneStadiumItem)

        let burussHall = CLLocationCoordinate2D(latitude: 37.229000, longitude: -80.423710)
        let burrussHallItem = MKMapItem(placemark: MKPlacemark(coordinate: burussHall))
        let burussHallDestination = Destination(burrussHallItem)
        
        let sut = SearchableMapViewModel()
        
        sut.searchResults = [laneStadiumDestination, burussHallDestination]
        
        #expect(sut.position == MapCameraPosition.item(laneStadiumItem))
    }
    
    @Test
    func search_withEmptyString_shouldSetSearchRedultsEmpty() async throws {
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider()
        let sut = SearchableMapViewModel(completer: completer, searchProvider: mockSearchProvider)
        
        await sut.search(for: "")
        
        #expect(sut.searchResults.isEmpty)
    }
    
    @Test
    func search_withValidString_shouldReturnNonEmptyArrayOfDestinations() async throws {
        let searchString = "Lane Stadium"
        let laneStadiumCoordinates = CLLocationCoordinate2D(latitude: laneStadiumLatitude, longitude: laneStadiumLongitude)
        let searchRegion = MKCoordinateRegion(center: laneStadiumCoordinates, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let laneStadiumPlacemark = MKPlacemark(coordinate: laneStadiumCoordinates)
        let laneStadiumMapItem = MKMapItem(placemark: laneStadiumPlacemark)
        let mockMapItems = [laneStadiumMapItem]
        
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockMapItems: mockMapItems)
        let sut = SearchableMapViewModel(completer: completer, searchProvider: mockSearchProvider)
        sut.visibleRegion = searchRegion
        
        await sut.search(for: searchString)
        
        #expect(!sut.searchResults.isEmpty)
    }
    
    @Test
    func search_withErrors_shouldSetSEarchREsultsEmpty() async {
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockError: NSError(domain: "Test Error", code: 1, userInfo: nil))
        let sut = SearchableMapViewModel(completer: completer, searchProvider: mockSearchProvider)
        
        await sut.search(for: "Error")
        
        #expect(sut.searchResults.isEmpty)
    }
    
    @Test
    func search_withSearchCompletion_shouldReturnNonEmptyArrayOfDestinations() async throws {
        let completion = MKLocalSearchCompletion()
        let laneStadiumCoordinates = CLLocationCoordinate2D(latitude: laneStadiumLatitude, longitude: laneStadiumLatitude)
        let searchRegion = MKCoordinateRegion(center: laneStadiumCoordinates, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let laneStadiumPlacemark = MKPlacemark(coordinate: laneStadiumCoordinates)
        let laneStadiumMapItem = MKMapItem(placemark: laneStadiumPlacemark)
        let mockMapItems = [laneStadiumMapItem]
        
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockMapItems: mockMapItems)
        let sut = SearchableMapViewModel(completer: completer, searchProvider: mockSearchProvider)
        sut.visibleRegion = searchRegion
        
        await sut.search(for: completion)
        
        #expect(!sut.searchResults.isEmpty)
    }
    
    @Test
    func search_withSearchCompletionAndErrors_shouldPropagateErrors() async {
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockError: NSError(domain: "Test Error", code: 1, userInfo: nil))
        let sut = SearchableMapViewModel(completer: completer, searchProvider: mockSearchProvider)
        
        await sut.search(for: MKLocalSearchCompletion())
        
        #expect(sut.searchResults.isEmpty)
    }
    
    @Test
    func update_withQueryFragment_shouldSetQueryFragment() {
        let completer = MKLocalSearchCompleter()
        let sut = SearchableMapViewModel(completer: completer)
        
        let queryFragment = "test"
        
        sut.update(queryFragment: queryFragment)
        
        #expect(completer.queryFragment == queryFragment)
    }
    
    @Test
    func update_withRegion_shouldSetCompleterRegion() {
        let completer = MKLocalSearchCompleter()
        let sut = SearchableMapViewModel(completer: completer)
        let location = CLLocationCoordinate2D(latitude: laneStadiumLatitude, longitude: laneStadiumLongitude)
        
        let region = MKCoordinateRegion(center: location, span: .init(latitudeDelta: 20, longitudeDelta: 20))
        
        sut.update(region: region)
        
        #expect(completer.region == region)
    }
}

extension MKCoordinateRegion: @retroactive Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center == rhs.center && lhs.span == rhs.span
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension MKCoordinateSpan: @retroactive Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}
