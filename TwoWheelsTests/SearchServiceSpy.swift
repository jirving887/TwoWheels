//
//  SearchServiceSpy.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/26.
//

import MapKit
@testable import TwoWheels

final class SearchServiceSpy: MapSearching {
    var receivedSearchRequests: [MKLocalSearch.Request] = []
    var dummyResults: [Location] = []
    var error: (any Error)?

    func search(with request: MKLocalSearch.Request) async throws -> [Location] {
        receivedSearchRequests.append(request)
        if let error {
            throw error
        }
        return dummyResults
    }
}
