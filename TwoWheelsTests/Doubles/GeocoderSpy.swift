//
//  GeocoderSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 5/10/25.
//

import CoreLocation
import Foundation
@testable import TwoWheels

class GeocoderSpy: Geocoding {
    var expectedPlacemarks: [CLPlacemark] = []
    var error: Error?
    var errorCount = 0
    
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark] {
        if let error {
            errorCount += 1
            throw error
        }
        return expectedPlacemarks
    }
}
