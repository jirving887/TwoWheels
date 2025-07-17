//
//  DestinationsListView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 9/24/24.
//

import MapKit
import SwiftUI

struct DestinationsListView: View {
    let destinations: [Destination]
    let tappedDestination: (Destination) -> Void

    var body: some View {
        List(destinations) { destination in
            Button {
                tappedDestination(destination)
            } label: {
                HStack {
                    Image(systemName: "mappin.circle")
                        .imageScale(.large)

                    Text(destination.title)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .contentShape(Rectangle())
            }
            .buttonStyle(PlainButtonStyle())
        }
    }
}

#Preview {
    var destinations: [Destination] = []
    for _ in 1..<10 {
        let laneStadiumDestination = Destination(latitude: 38.22001, longitude: -81.41804, title: "Lane Stadium")
        destinations.append(laneStadiumDestination)
    }
    
    return DestinationsListView(destinations: destinations) { _ in }
}
