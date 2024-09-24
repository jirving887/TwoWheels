//
//  DestinationsListView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 9/24/24.
//

import SwiftUI
import SwiftData

struct DestinationsListView: View {
    
    @Environment(\.modelContext) private var modelContext
    @Query(sort: \Destination.name) private var destinations: [Destination]
    
    var body: some View {
        NavigationStack {
            if !destinations.isEmpty {
                List(destinations) { destination in
                    HStack {
                        Image(systemName: "mappin.circle")
                            .imageScale(.large)
                        
                        VStack(alignment: .leading) {
                            Text(destination.name)
                                
                            Text(destination.type)
                                .font(.caption)
                                .foregroundStyle(.secondary)
                        }
                    }
                    .swipeActions(edge: .trailing) {
                        Button(role: .destructive) {
                            modelContext.delete(destination)
                        } label: {
                            Label("Delete", systemImage: "trash")
                        }
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
    DestinationsListView()
}
