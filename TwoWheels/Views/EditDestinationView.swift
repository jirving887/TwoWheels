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
    
    let destination: Destination
    let title: String
    let dismiss: () -> Void
    
    @State private var destinationName: String
    @State private var destinationAddress: String
    
    init(destination: Destination, title: String, dismiss: @escaping () -> Void) {
        self.destination = destination
        self.title = title
        self.dismiss = dismiss
        
        _destinationName = .init(initialValue: destination.title)
        _destinationAddress = .init(initialValue: destination.address ?? "No Address")
    }
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Destination Name", text: $destinationName)
                }
                
                Section(header: Text("Address")) {
                    TextField("Destination Address", text: $destinationAddress, axis: .vertical)
                        .lineLimit(1...5)
                }
            }
            .navigationTitle(title)
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        destination.title = destinationName
                        destination.address = destinationAddress
                        
                        modelContext.insert(destination)
                        
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
    
    EditDestinationView(destination: laneStadiumDestination, title: "Save or Edit Destination:") {
        print("CANCEL")
    }
        .modelContainer(container)
}
