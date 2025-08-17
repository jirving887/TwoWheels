//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import Foundation
import CoreLocation

@Observable
final class ExploreViewModel {
    let locationManager: any Locating

    init(locationManager: any Locating) {
        self.locationManager = locationManager
        self.locationManager.requestWhenInUseAuthorization()
    }
}

protocol Locating {
    func requestWhenInUseAuthorization()
}

extension CLLocationManager: Locating {}
