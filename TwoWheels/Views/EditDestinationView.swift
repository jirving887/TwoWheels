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
    @Environment(\.modelContext) var modelContext
    @Environment(\.dismiss) private var dismiss
    
    @Bindable var destination: Destination
    let newDestination: Bool
    
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
                    Button("Save") {
                        if newDestination {
                            modelContext.insert(destination)
                        }
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    let laneStadium = CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804)
    let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
    let laneStadiumDestination = Destination(laneStadiumItem)
    
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Destination.self, configurations: config)
    
    EditDestinationView(destination: laneStadiumDestination, newDestination: true)
        .modelContainer(container)
}
