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
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Destination.title) private var destinations: [Destination]
    
    @State private var selectedDestination: Destination?
    
    var body: some View {
        NavigationStack {
            if !destinations.isEmpty {
                List(destinations) { destination in
                    HStack {
                        Image(systemName: "mappin.circle")
                            .imageScale(.large)
                        
                        VStack(alignment: .leading) {
                            Text(destination.title)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            modelContext.delete(destination)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
                        
                        Button {
                            selectedDestination = destination
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
        .sheet(item: $selectedDestination) { destination in
            EditDestinationView(destination: destination, newDestination: false)
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Destination.self, configurations: config)
    
    for _ in 1..<10 {
        let laneStadiumDestination = Destination(latitude: 38.22001, longitude: -81.41804, title: "Lane Stadium")
        
        container.mainContext.insert(laneStadiumDestination)
    }
    
    return DestinationsListView()
        .modelContainer(container)
}
