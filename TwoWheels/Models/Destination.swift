//
//  Destination.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 9/24/24.
//

import MapKit
import SwiftData

@Model
class Destination {
    var name: String
    var adddress: String
    var latitude: Double
    var longitude: Double
    
    init(name: String, adddress: String, latitude: Double, longitude: Double) {
        self.name = name
        self.adddress = adddress
        self.latitude = latitude
        self.longitude = longitude
    }
    
    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
