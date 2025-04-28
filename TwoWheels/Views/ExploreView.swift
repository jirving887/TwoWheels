//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import SwiftUI

struct ExploreView: View {
    
    @State private var viewModel = ExploreViewModel()
    
    var body: some View {
        TabView(selection: $viewModel.selectedTab) {
            Tab("Map", systemImage: "map", value: .map) {
                SearchableMapView()
            }
            
            Tab("Destinations", systemImage: "list.bullet", value: .list) {
                DestinationsListView()
            }
        }
    }
}

#Preview {
    ExploreView()
}
