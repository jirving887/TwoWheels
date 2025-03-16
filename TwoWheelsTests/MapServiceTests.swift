//
//  MapServiceTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 10/24/24.
//

import Testing
import MapKit
@testable import TwoWheels

final class MapServiceTests {
    
    var latitude: CLLocationDegrees
    var longitude: CLLocationDegrees
    
    init() {
        latitude = 37.22001
        longitude = 80.41804
    }
    
    deinit {
        latitude = 0
        longitude = 0
    }
    
    @Test
    func onInit_shouldSetCompleterDelegate() {
        let completer = MKLocalSearchCompleter()
        
        let sut = MapService(completer: completer)
        
        #expect(completer.delegate === sut)
    }
    
    @Test
    func update_withRegion_shouldSetCompleterRegion() {
        let completer = MKLocalSearchCompleter()
        let sut = MapService(completer: completer)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: location, span: .init(latitudeDelta: 20, longitudeDelta: 20))
        
        sut.update(region: region)
        
        #expect(completer.region == region)
    }
    
    @Test
    func update_withQueryFragment_shouldSetQueryFragment() {
        let completer = MKLocalSearchCompleter()
        let sut = MapService(completer: completer)
        
        let queryFragment = "test"
        
        sut.update(queryFragment: queryFragment)
        
        #expect(completer.queryFragment == queryFragment)
    }
    
    @Test
    func search_withEmptyString_shouldReturnEmptyArray() async throws {
        let searchString = ""
        let searchCenter = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let searchRegion = MKCoordinateRegion(center: searchCenter, latitudinalMeters: 10000, longitudinalMeters: 10000)
        
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider()
        let sut = MapService(completer: completer, searchProvider: mockSearchProvider)
        
        #expect(try await sut.search(for: searchString, in: searchRegion).isEmpty)
    }
    
    @Test
    func search_withValidString_shouldReturnNonEmptyArrayOfDestinations() async throws {
        let searchString = "Lane Stadium"
        let laneStadiumCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let searchRegion = MKCoordinateRegion(center: laneStadiumCoordinates, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let laneStadiumPlacemark = MKPlacemark(coordinate: laneStadiumCoordinates)
        let laneStadiumMapItem = MKMapItem(placemark: laneStadiumPlacemark)
        let mockMapItems = [laneStadiumMapItem]
        
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockMapItems: mockMapItems)
        let sut = MapService(completer: completer, searchProvider: mockSearchProvider)
        
        let searchResults = try await sut.search(for: searchString, in: searchRegion)
        
        #expect(!searchResults.isEmpty)
    }
    
    @Test
    func search_withErrors_shouldPropagateErrors() async {
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockError: NSError(domain: "Test Error", code: 1, userInfo: nil))
        let sut = MapService(completer: completer, searchProvider: mockSearchProvider)
        
        await #expect(throws: (any Error).self) {
            try await sut.search(for: "Lane Stadium", in: MKCoordinateRegion())
        }
    }
    
    @Test
    func search_withSearchCompletion_shouldReturnNonEmptyArrayOfDestinations() async throws {
        let completion = MKLocalSearchCompletion()
        let laneStadiumCoordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let searchRegion = MKCoordinateRegion(center: laneStadiumCoordinates, latitudinalMeters: 10000, longitudinalMeters: 10000)
        let laneStadiumPlacemark = MKPlacemark(coordinate: laneStadiumCoordinates)
        let laneStadiumMapItem = MKMapItem(placemark: laneStadiumPlacemark)
        let mockMapItems = [laneStadiumMapItem]
        
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockMapItems: mockMapItems)
        let sut = MapService(completer: completer, searchProvider: mockSearchProvider)
        
        let searchResults = try await sut.search(for: completion, in: searchRegion)
        print(searchResults)
        #expect(!searchResults.isEmpty)
    }
    
    @Test
    func search_withSearchCompletionAndErrors_shouldPropagateErrors() async {
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockError: NSError(domain: "Test Error", code: 1, userInfo: nil))
        let sut = MapService(completer: completer, searchProvider: mockSearchProvider)
        
        await #expect(throws: (any Error).self) {
            try await sut.search(for: MKLocalSearchCompletion(), in: MKCoordinateRegion())
        }
    }
    
    @Test
    func address_withLocation_shouldReturnStringAddress() async throws {
        let laneStadiumLocation = CLLocation(latitude: 37.219716, longitude: -80.418147)
        let laneStadiumLocation2D = CLLocationCoordinate2D(latitude: 37.219716, longitude: -80.418147)
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
        let sut = MapService(completer: completer, searchProvider: mockSearchProvider)
        
        let address = try await sut.address(from: laneStadiumLocation)
        
        #expect("185 Beamer Way Blacksburg, VA 24061 United States".contains(address.trimmingCharacters(in: .whitespaces)))
    }
    
    @Test
    func address_withLocationAndErrors_shouldPropogarateErrors() async {
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockError: NSError(domain: "Test Error", code: 1, userInfo: nil))
        let sut = MapService(completer: completer, searchProvider: mockSearchProvider)
        
        await #expect(throws: (any Error).self) {
            try await sut.address(from: CLLocation())
        }
    }
}


