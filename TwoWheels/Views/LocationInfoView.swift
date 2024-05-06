//
//  LocationInfoView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/1/24.
//
//import CoreLocation
import MapKit
import SwiftUI

struct LocationInfoView: View {
    
    let location: MKMapItem
    
    var body: some View {
        VStack {
            Text(location.placemark.title ?? "No Title")
            Text(location.placemark.subtitle ?? "No Subtitle")
//            Text(location.url?.absoluteString ?? "No url")
//            Text(location.id.uuidString)
        }
        .presentationDetents([.fraction(0.20), .fraction(0.33)])
        .presentationBackground(.regularMaterial)
        .interactiveDismissDisabled()
        .presentationBackgroundInteraction(.enabled)
    }
}

//#Preview {
//    LocationInfoView(location: .init(location: CLLocationCoordinate2D(latitude: 37.65729684192488, longitude: -77.1791187289185), title: "Preview Title", subTitle: "Preview subtitle", url: URL(string: "URL")))
//}
