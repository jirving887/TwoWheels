//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import SwiftData
import SwiftUI

struct ExploreView: View {
    
    @State private var viewModel: ExploreViewModel
    
    init(modelContext: ModelContext) {
        let dataService = DataService<Destination>(modelContext: modelContext)
        let viewModel = ExploreViewModel(dataService: dataService)
        _viewModel = State(initialValue: viewModel)
    }
    
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
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Destination.self, configurations: config)
    
    ExploreView(modelContext: container.mainContext)
}
