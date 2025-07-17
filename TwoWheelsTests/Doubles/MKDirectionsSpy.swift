//
//  MKDirectionsSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 6/29/25.
//

import MapKit

class MKDirectionsSpy: MKDirections {
    var calculateCount = 0

    override func calculate() async throws -> MKDirections.Response {
        calculateCount += 1
        return .init()
    }
}
