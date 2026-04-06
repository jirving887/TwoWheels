//
//  MapSearching.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/6/26.
//

import MapKit

protocol MapSearching {
    func search(with request: MKLocalSearch.Request) async throws -> [Location]
}
