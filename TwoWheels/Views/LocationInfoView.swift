//
//  LocationInfoView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/1/24.
//

import MapKit
import SwiftUI

struct LocationInfoView: View {
    
    let location: MKMapItem
    
    var body: some View {
        VStack {
            Text(location.placemark.title ?? "No Title")
            Text(location.placemark.subtitle ?? "No Subtitle")
        }
        .presentationDetents([.fraction(0.20), .fraction(0.33)])
        .presentationBackground(.regularMaterial)
        .interactiveDismissDisabled()
        .presentationBackgroundInteraction(.enabled)
    }
}
