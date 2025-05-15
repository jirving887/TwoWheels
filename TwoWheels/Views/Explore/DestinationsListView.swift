//
//  DestinationsListView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 9/24/24.
//

import MapKit
import SwiftUI
import SwiftData

struct DestinationsListView: View {
    @Environment(ExploreViewModel.self) var viewModel
    
    var body: some View {
        NavigationStack {
            if !viewModel.destinations.isEmpty {
                List(viewModel.destinations, id: \.self) { destination in
                    HStack {
                        Image(systemName: "mappin.circle")
                            .imageScale(.large)
                        
                        VStack(alignment: .leading) {
                            Text(destination.title)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            viewModel.deleteDestination(destination)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            viewModel.editingDestination = destination
                        } label: {
                            Label("Edit", systemImage: "pencil")
                        }
                        .tint(.yellow)
                    }
                }
            } else {
                ContentUnavailableView(
                    "No Destinations saved!",
                    systemImage: "mappin.slash.circle",
                    description: Text("You have not saved any locations yet. Check out the Map \(Image(systemName: "map")) and add one.")
                )
            }
        }
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
    
    for _ in 1..<10 {
        let laneStadiumDestination = Destination(latitude: 38.22001, longitude: -81.41804, title: "Lane Stadium")
        
        container.mainContext.insert(laneStadiumDestination)
    }
    
    let dataService = DataService<Destination>(modelContext: container.mainContext)
    let viewModel = ExploreViewModel(
        dataService: dataService,
        searchService: SearchService(),
        geocoder: CLGeocoder()
    )
    
    return DestinationsListView()
        .modelContainer(container)
        .environment(viewModel)
}
