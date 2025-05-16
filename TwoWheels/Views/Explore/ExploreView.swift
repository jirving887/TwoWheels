//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import CoreLocation
import SwiftData
import SwiftUI

struct ExploreView: View {
    @State private var viewModel: ExploreViewModel
    
    init(modelContext: ModelContext) {
        let dataService = DataService<Destination>(modelContext: modelContext)
        let searchService = SearchService()
        let geocoder = CLGeocoder()
        let viewModel = ExploreViewModel(
            dataService: dataService,
            searchService: searchService,
            geocoder: geocoder
        )
        _viewModel = State(initialValue: viewModel)
    }
    
    var body: some View {
        MapView()
            .sheet(isPresented: $viewModel.isSearchSheetPresented) {
                SearchSheetView()
            }
            .sheet(item: $viewModel.editingDestination) {
                EditDestinationView(destination: $0)
            }
            .sheet(isPresented: $viewModel.isInfoSheetPresented) {
                viewModel.selectedDestination = nil
            } content: {
                if let location = viewModel.selectedDestination {
                    LocationInfoView(location: location)
                }
            }
            .sheet(isPresented: $viewModel.isListSheetPresented) {
                DestinationsListView()
            }
            .environment(viewModel)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container: ModelContainer
    do {
        container = try ModelContainer(for: Destination.self, configurations: config)
    } catch {
        fatalError("Failed to create in-memory container: \(error)")
    }
    
    return ExploreView(modelContext: container.mainContext)
}
