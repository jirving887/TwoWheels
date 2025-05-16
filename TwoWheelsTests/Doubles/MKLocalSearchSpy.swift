//
//  MKLocalSearchSpy.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/15/25.
//

import MapKit

class MKLocalSearchSpy: MKLocalSearch {
    var startCount = 0
    
    override func start() async throws -> MKLocalSearch.Response {
        startCount += 1
        return .init()
    }
}
