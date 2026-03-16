//
//  Location.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/26.
//

import CoreLocation

struct Location: Hashable {
    let name: String
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
}
