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
    func search_withSearchCompletionAndErrors_shouldPropagateErrors() async {
        let completer = MKLocalSearchCompleter()
        let mockSearchProvider = MockSearchProvider(mockError: NSError(domain: "Test Error", code: 1, userInfo: nil))
        let sut = MapService(completer: completer, searchProvider: mockSearchProvider)
        
        await #expect(throws: (any Error).self) {
            try await sut.search(for: MKLocalSearchCompletion(), in: MKCoordinateRegion())
        }
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
