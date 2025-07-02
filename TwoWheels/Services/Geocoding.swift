//
//  Geocoding.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/10/25.
//

import CoreLocation
import Foundation

protocol Geocoding: Sendable {
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark]
}

extension CLGeocoder: Geocoding, @unchecked @retroactive Sendable {}
