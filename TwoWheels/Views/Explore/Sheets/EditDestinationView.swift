//
//  EditDestinationView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/23/25.
//

import SwiftUI
import SwiftData
import MapKit

struct EditDestinationView: View {
    @Environment(ExploreViewModel.self) var viewModel
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var destination: Destination
    var newDestination: Bool {
        !viewModel.destinations.contains(destination)
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Destination Name", text: $destination.title)
                }
                
                Section(header: Text("Address")) {
                    TextField("Destination Address", text: $destination.address, axis: .vertical)
                        .lineLimit(1...5)
                }
            }
            .navigationTitle("\(newDestination ? "New" : "Edit") Destination")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button(newDestination ? "Add" : "Save") {
                        if newDestination {
                            viewModel.addDestination(destination)
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let laneStadiumDestination = Destination(latitude: 38.22001, longitude: -81.41804, title: "Lane Stadium")
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container: ModelContainer
    do {
        container = try ModelContainer(for: Destination.self, configurations: config)
    } catch {
        fatalError("Failed to create in-memory container: \(error)")
    }
    
    let dataService = DataService<Destination>(modelContext: container.mainContext)
    let viewModel = ExploreViewModel(
        dataService: dataService,
        searchService: SearchService { MKLocalSearch(request: $0) },
        geocoder: CLGeocoder(),
        directionsService: DirectionsService {
            MKDirections(request: $0)
        } updates: {
            CLLocationUpdate.liveUpdates()
        }
    )
    
    return EditDestinationView(destination: laneStadiumDestination)
        .modelContainer(container)
        .environment(viewModel)
}
