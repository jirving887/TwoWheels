//
//  Destination.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 9/24/24.
//

import MapKit
import SwiftData
import SwiftUI

@Model
class Destination: MapSelectable {

    @Transient
    var feature: MapFeature?
    var title: String
    var address: String
    var longitude: Double
    var latitude: Double
    var url: URL?

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }

    init(_ mapItem: MKMapItem) {
        title = mapItem.name ?? ""
        address = ""
        latitude = mapItem.placemark.coordinate.latitude
        longitude = mapItem.placemark.coordinate.longitude
        url = mapItem.url
    }

    convenience init(latitude: Double, longitude: Double, title: String = "") {
        let coordinates = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        let placemark = MKPlacemark(coordinate: coordinates)
        let item = MKMapItem(placemark: placemark)
        item.name = title
        self.init(item)
    }

    required convenience init(_ feature: MapFeature?) {
        let placemark = MKPlacemark(coordinate: feature?.coordinate ?? CLLocationCoordinate2D())
        let item = MKMapItem(placemark: placemark)
        item.name = feature?.title ?? ""
        self.init(item)
        self.feature = feature
    }
}
