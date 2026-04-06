//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import MapKit
import SwiftUI

struct ExploreView<ViewModel: ExploreViewModelProtocol, LocationDetailView: View>: View {
    @Bindable var viewModel: ViewModel
    @ViewBuilder let locationDetailView: (Location) -> LocationDetailView

    var body: some View {
        NavigationStack {
            Map(position: $viewModel.mapPosition, selection: $viewModel.mapSelection) {
                UserAnnotation()
            }
            .onMapCameraChange(frequency: .onEnd) { newPos in
                viewModel.visibleRegion = newPos.region
            }
            .searchable(text: $viewModel.searchText)
            .searchSuggestions {
                if viewModel.searchText.isEmpty {
                    Label("No results, yet...", systemImage: "magnifyingglass")
                } else {
                    ForEach(viewModel.searchCompletions) { completionInfo in
                        SearchCompletionView(completionInfo: completionInfo)
                            .searchCompletion(completionInfo.title)
                    }
                }
            }
            .onSubmit(of: .search) {
                Task {
                    viewModel.search()
                }
            }
            .sheet(isPresented: $viewModel.isShowingDetailSheet, onDismiss: viewModel.didDismissDetailSheet, content: {
                if let location = viewModel.selectedLocation {
                    LocationDetailSheet(location: location)
                }
            })
        }
    }
}

#Preview {
    ExploreView(viewModel: MockExploreViewModel()) { location in
        Text("Detail Sheet for \(location.name)")
    }
}
