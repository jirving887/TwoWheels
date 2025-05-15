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
    
    /// Simulates reverse geocoding for a given location.
    ///
    /// Returns a predefined array of placemarks or throws a preset error for testing purposes. Increments the error count each time an error is thrown.
    ///
    /// - Parameter location: The location to reverse geocode.
    /// - Returns: An array of `CLPlacemark` objects representing the simulated geocoding result.
    /// - Throws: The preset error if one is configured.
    func reverseGeocodeLocation(_ location: CLLocation) async throws -> [CLPlacemark] {
        if let error {
            errorCount += 1
            throw error
        }
        return expectedPlacemarks
    }
}
