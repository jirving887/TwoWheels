//
//  TwoWheelsApp.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/5/24.
//

import CoreLocation
import SwiftUI

struct TwoWheelsApp: App {
    private let locationManager = CLLocationManager()

    init() {
        locationManager.requestWhenInUseAuthorization()
    }

    var body: some Scene {
        WindowGroup {
            Text("TwoWheels")
        }
    }
}
