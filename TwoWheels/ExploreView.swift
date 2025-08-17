//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import MapKit
import SwiftUI

struct ExploreView: View {
    @State private var viewModel = ExploreViewModel(locationManager: CLLocationManager())

    var body: some View {
        NavigationStack {
            Map(position: $viewModel.mapPosition) {
                UserAnnotation()
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
    }
}

#Preview {
    ExploreView()
}
