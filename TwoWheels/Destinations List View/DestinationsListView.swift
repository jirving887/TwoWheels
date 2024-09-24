//
//  DestinationsListView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 9/24/24.
//

import SwiftUI
import SwiftData

struct DestinationsListView: View {
    
    @Query(sort: \Destination.name) private var destinations: [Destination]
    
    var body: some View {
        if !destinations.isEmpty {
            Text("Filler")
        } else {
            ContentUnavailableView(
                "No Destinations saved!",
                systemImage: "mappin.slash.circle",
                description: Text("You have not saved any locations yet. Tap on the \(Image(systemName: "plus.circle.fill")) button in the toolbar to add one.")
            )
        }
    }
}

#Preview {
    DestinationsListView()
}
