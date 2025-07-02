//
//  DirectionsServiceTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 6/29/25.
//

import MapKit
import Testing
@testable import TwoWheels

struct DirectionsServiceTests {

    @Test
    func getDirections_shouldCallCalculate() async throws {
        var directionsSpy = MKDirectionsSpy(request: .init())
        let sut = await DirectionsService {
            directionsSpy = MKDirectionsSpy(request: $0)
            return directionsSpy
        } updates: { CLLocationUpdatesFake(current: .init()) }
        
        _ = try await sut.getDirections(with: .init())
        
        #expect(directionsSpy.calculateCount == 1)
    }
    
    @Test
    func getUserMapItem_shouldReturnMapItem() async throws {
        let laneStadiumLocation = CLLocation(latitude: 37.22001, longitude: -80.41804)
        var directionsSpy = MKDirectionsSpy(request: .init())
        let sut = await DirectionsService {
            directionsSpy = MKDirectionsSpy(request: $0)
            return directionsSpy
        } updates: {
            CLLocationUpdatesFake(current: CLLocationUpdateFake(location: laneStadiumLocation))
        }
        
        let result = try await sut.getUserMapItem()
        
        #expect(result?.placemark.coordinate.latitude == laneStadiumLocation.coordinate.latitude)
        #expect(result?.placemark.coordinate.longitude == laneStadiumLocation.coordinate.longitude)
    }
}
