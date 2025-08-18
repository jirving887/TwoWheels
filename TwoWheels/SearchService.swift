//
//  SearchService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/18/25.
//

import Foundation
import MapKit

@MainActor
protocol Searching {
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem]
}

class SearchService: Searching {
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        []
    }
}
