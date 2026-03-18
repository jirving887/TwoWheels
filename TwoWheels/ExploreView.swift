//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import MapKit
import SwiftUI

struct ExploreView: View {
    @State private var viewModel = ExploreViewModel(searchDataSource: MapSearchDataSource())

    var body: some View {
        NavigationStack {
            Map(position: $viewModel.mapPosition, selection: $viewModel.mapSelection) {
                UserAnnotation()
            }
            .onMapCameraChange(frequency: .onEnd) { newPos in
                viewModel.visibleRegion = newPos.region
            }
            .searchable(text: $viewModel.searchText) {
                Text("Search View")
            }
            .onSubmit(of: .search) {
                Task {
                    await viewModel.search()
                }
            }
            .sheet(isPresented: $viewModel.isShowingDetailSheet) {
                viewModel.didDismissDetailSheet()
            } content: {
                if let location = viewModel.selectedLocation {
                    LocationDetailSheet(location: location)
                        .presentationDetents([.medium])
                        .presentationBackgroundInteraction(.enabled)
                }
            }
        }
    }
}

#Preview {
    ExploreView()
}
