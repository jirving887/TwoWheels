//
//  LocationManager.swift
//  TwoWheels
//
//  Created on 3/15/26.
//

import CoreLocation

@MainActor
@Observable
final class LocationManager {
    var currentLocation: CLLocation?
}
