//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import MapKit
import SwiftUI

struct ExploreView<DetailSheet: View>: View {
    private let makeDetailSheet: () -> DetailSheet

    @State private var viewModel = ExploreViewModel(locationManager: CLLocationManager())

    init(@ViewBuilder detailSheet makeDetailSheet: @escaping () -> DetailSheet) {
        self.makeDetailSheet = makeDetailSheet
    }

    var body: some View {
        NavigationStack {
            Map(position: $viewModel.mapPosition, selection: $viewModel.selectedLocation) {
                UserAnnotation()
            }
            .edgesIgnoringSafeArea(.all)
            .navigationBarHidden(true)
        }
        .sheet(isPresented: $viewModel.isShowingDetailSheet) {
            viewModel.didDismissDetailSheet()
        } content: {
            makeDetailSheet()
        }
    }
}

#Preview {
    ExploreView { Text("Detail Sheet") }
}
