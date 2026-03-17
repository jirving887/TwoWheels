//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import MapKit
import SwiftUI

struct ExploreView: View {
    @State private var viewModel = ExploreViewModel(searchDataSource: nil)
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Map(position: $viewModel.mapPosition, selection: $viewModel.mapSelection) {
                UserAnnotation()
            }
            .searchable(text: $viewModel.searchText) {
                Text("Search View")
            }
            .onSubmit(of: .search) {
                print("Searching")
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
