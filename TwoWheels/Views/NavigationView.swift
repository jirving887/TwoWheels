//
//  NavigationView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 7/2/25.
//

import MapKit
import SwiftUI

struct NavigationView: View {
    @State private var position = MapCameraPosition.userLocation(fallback: .automatic)
    @State private var bounds = MapCameraBounds(minimumDistance: 500, maximumDistance: 1000)
    let route: MKRoute

    var body: some View {
        Map(position: $position, bounds: bounds, interactionModes: [.zoom, .pitch]) {
            MapPolyline(route)
                .stroke(.blue, style: StrokeStyle(
                        lineWidth: 5,
                        lineCap: .round,
                        lineJoin: .round
                    )
                )

            UserAnnotation()
        }
    }
}

#Preview {
    NavigationView(route: .init())
}
