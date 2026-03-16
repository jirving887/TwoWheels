//
//  LocationDetailSheet.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import MapKit
import SwiftUI

struct LocationDetailSheet: View {
    let mapItem: MKMapItem
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}

#Preview {
    LocationDetailSheet()
    let item = MKMapItem(
        location: CLLocation(latitude: 37.7749, longitude: -122.4194),
        address: MKAddress(fullAddress: "123 Main St\nSan Francisco, CA 94105", shortAddress: "123 Main St, San Francisco")
    )
    item.name = "Golden Gate Cyclery"
    return LocationDetailSheet(mapItem: item)
}
