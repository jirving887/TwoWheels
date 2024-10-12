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
class Destination : MapSelectable {
    
    @Transient
    var feature: MapFeature?
    @Transient
    var mapItem: MKMapItem?
    var title: String
    var longitude: Double
    var latitude: Double
    var url: URL?
    
    var coordinate: CLLocationCoordinate2D {
        get {
            return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
        }
    }
    
    init(_ mapItem: MKMapItem) {
        self.mapItem = mapItem
        self.title = mapItem.name ?? ""
        self.latitude = mapItem.placemark.coordinate.latitude
        self.longitude = mapItem.placemark.coordinate.longitude
        self.url = mapItem.url
    }
    
    required convenience init(_ feature: MapFeature?) {
        let placemark = MKPlacemark(coordinate: feature?.coordinate ?? CLLocationCoordinate2D())
        let item = MKMapItem(placemark: placemark)
        item.name = feature?.title ?? ""
        self.init(item)
        self.feature = feature
    }
}
