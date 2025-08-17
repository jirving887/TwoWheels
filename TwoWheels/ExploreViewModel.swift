//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import Foundation
import _MapKit_SwiftUI

@Observable
final class ExploreViewModel {
    private let locationManager: any Locating

    var mapPosition = MapCameraPosition.userLocation(fallback: .automatic)
    var selectedLocation: MapFeature?

    init(locationManager: any Locating) {
        self.locationManager = locationManager
        self.locationManager.requestWhenInUseAuthorization()
    }
}

protocol Locating {
    func requestWhenInUseAuthorization()
}

extension CLLocationManager: Locating {}
