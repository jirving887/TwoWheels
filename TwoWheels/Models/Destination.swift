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
    var url: URL?
    
    init(_ mapItem: MKMapItem) {
        self.mapItem = mapItem
        self.title = mapItem.name ?? ""
        self.address = mapItem.placemark.thoroughfare ?? mapItem.placemark.title ?? ""
    }
    
    required init(_ feature: MapFeature?) {
        self.feature = feature
        let placemark = MKPlacemark(coordinate: feature?.coordinate ?? CLLocationCoordinate2D())
        mapItem = MKMapItem(placemark: placemark)
        title = feature?.title ?? ""
        address = placemark.thoroughfare ?? placemark.title ?? ""
        
    }
}
