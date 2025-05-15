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
    var expectedSearchCompletions: [MKLocalSearchCompletion] = []
    var searchRegion: MKCoordinateRegion?
    var error: Error?
    var errorCount = 0
    
    /// Performs a simulated map search using the provided request.
    ///
    /// If an error is set, increments the error count and throws the error. Otherwise, returns the predefined search results.
    ///
    /// - Parameter request: The search request to simulate.
    /// - Returns: An array of map items representing the simulated search results.
    /// - Throws: The configured error if one is set.
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        if let error {
            errorCount += 1
            throw error
        }
        return expectedSearchResults
    }
}
