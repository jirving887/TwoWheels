//
//  SearchServiceSpy.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/26.
//

import MapKit
@testable import TwoWheels

final class SearchServiceSpy: MapSearching {
    var recievedSearchRequests: [MKLocalSearch.Request] = []

    func search(with request: MKLocalSearch.Request) async throws -> [Location] {
        recievedSearchRequests.append(request)
        return []
    }
}
