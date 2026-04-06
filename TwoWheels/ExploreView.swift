//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import MapKit
import SwiftUI

struct ExploreView<ViewModel: ExploreViewModelProtocol>: View {
    @Bindable var viewModel: ViewModel

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
                Text("Search View")
            }
            .onSubmit(of: .search) {
                Task {
                    viewModel.search()
                }
            }
        }
    }
}

#Preview {
    ExploreView(viewModel: MockExploreViewModel())
}
