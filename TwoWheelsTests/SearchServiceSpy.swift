//
//  SearchServiceSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 8/18/25.
//

import Foundation
import MapKit
@testable import TwoWheels

class SearchServiceSpy: Searching {
    var callCount = 0

    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        callCount += 1
        return []
    }
}
