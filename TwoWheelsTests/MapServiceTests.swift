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
    func search_withQueryAndRegion_shouldReturnDestinations() async throws {
        let completer = MKLocalSearchCompleter()
        let sut = MapService(completer: completer)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: .init(latitudeDelta: 20, longitudeDelta: 20))
        let query = "coffee"
        
        let results = try await sut.search(with: query, region: completer.region)
        print(results.count)
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
