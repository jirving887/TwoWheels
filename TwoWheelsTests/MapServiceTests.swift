//
//  MapServiceTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 10/24/24.
//

import XCTest
import MapKit
@testable import TwoWheels

final class MapServiceTests: XCTestCase {
    
    let latitude = 37.22001
    let longitude = 80.41804
    
    func test_onInit_completerDelegateIsSet() {
        let completer = MKLocalSearchCompleter()
        let service = MapService(completer: completer)
        
        XCTAssert(completer.delegate === service)
    }
    
    func test_update_regionIsSet() {
        let completer = MKLocalSearchCompleter()
        let service = MapService(completer: completer)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        
        let region = MKCoordinateRegion(center: location, span: .init(latitudeDelta: 20, longitudeDelta: 20))
        
        service.update(region: region)
        
        XCTAssertEqual(completer.region, region)
    }
    
    func test_update_queryFragmentIsSet() {
        let completer = MKLocalSearchCompleter()
        let service = MapService(completer: completer)
        
        let queryFragment = "test"
        
        service.update(queryFragment: queryFragment)
        
        XCTAssert(completer.queryFragment == queryFragment)
    }
    
    func test_search_withQuery() async throws {
        let completer = MKLocalSearchCompleter()
        let service = MapService(completer: completer)
        let location = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let region = MKCoordinateRegion(center: location, span: .init(latitudeDelta: 20, longitudeDelta: 20))
        let query = "coffee"
        
        let results = try await service.search(with: query, region: completer.region)
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
