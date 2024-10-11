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
    var address: String
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
        self.address = mapItem.placemark.thoroughfare ?? mapItem.placemark.title ?? ""
        self.latitude = mapItem.placemark.coordinate.latitude
        self.longitude = mapItem.placemark.coordinate.longitude
        self.url = mapItem.url
    }
    
    required init(_ feature: MapFeature?) {
        self.feature = feature
        let placemark = MKPlacemark(coordinate: feature?.coordinate ?? CLLocationCoordinate2D())
        mapItem = MKMapItem(placemark: placemark)
        title = feature?.title ?? ""
        address = ""
        latitude = feature?.coordinate.latitude ?? 0
        longitude = feature?.coordinate.longitude ?? 0
    }
}
