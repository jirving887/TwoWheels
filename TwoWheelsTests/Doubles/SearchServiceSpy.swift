//
//  SearchServiceSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 4/29/25.
//

import Foundation
import MapKit
@testable import TwoWheels

class SearchServiceSpy: MapSearching {
    var expectedSearchResults: [MKMapItem] = []
    var error: (any Error)?
    var errorCount = 0
    
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        if let error {
            errorCount += 1
            throw error
        }
        return expectedSearchResults
    }
}
