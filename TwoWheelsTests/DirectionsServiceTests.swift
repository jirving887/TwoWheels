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
        let sut = DirectionsService {
            directionsSpy = MKDirectionsSpy(request: $0)
            return directionsSpy
        }
        
        _ = try await sut.getDirections(with: .init())
        
        #expect(directionsSpy.calculateCount == 1)
    }

}
