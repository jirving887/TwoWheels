//
//  Location+MapKit.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/26.
//

import _MapKit_SwiftUI

extension Location {
    init(from feature: MapFeature) {
        self.init(
            name: feature.title ?? "Unknown Location",
            latitude: feature.coordinate.latitude,
            longitude: feature.coordinate.longitude
        )
    }
}
