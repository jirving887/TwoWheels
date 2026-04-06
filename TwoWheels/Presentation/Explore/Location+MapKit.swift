//
//  Location+MapKit.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/26.
//

import _MapKit_SwiftUI

extension Location {
    var coordinates: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(from feature: MapFeature) {
        self.init(
            name: feature.title ?? "Unknown Location",
            latitude: feature.coordinate.latitude,
            longitude: feature.coordinate.longitude
        )
    }
}
