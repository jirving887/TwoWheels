//
//  LocationInfoView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/1/24.
//

import MapKit
import SwiftData
import SwiftUI

struct LocationInfoView: View {
    @Environment(SearchableMapViewModel.self) var viewModel
    @Query private var destinations: [Destination]
    
    let location: Destination
    
    var saved: Bool {
        destinations.contains(location)
    }
    
    var body: some View {
        VStack() {
            VStack(alignment: .leading) {
                Text(location.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text(location.address)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            
            HStack(alignment: .center, spacing: 10.0) {
                Button {
                    // TODO: Implement navigation initiation
                } label: {
                    VStack {
                        Image(systemName: "road.lanes.curved.right")
                            .padding(2)
                        Text("Navigate")
                    }
                    .frame(maxHeight: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.blue)
                .frame(width: UIScreen.main.bounds.width / 4)
                
                Button {
                    viewModel.isInfoSheetPresented = false
                    viewModel.isEditSheetPresented = true
                } label: {
                    VStack {
                        Image(systemName: saved ? "pencil" : "plus.circle")
                            .padding(2)
                        Text(saved ? "Edit Destination" : "Add Destination")
                    }
                    .frame(maxHeight: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(saved ? .yellow : .green)
                .frame(width: UIScreen.main.bounds.width / 4)
                
                if let url = location.url {
                    Button {
                        UIApplication.shared.open(url)
                    } label: {
                        VStack {
                            Image(systemName: "link")
                                .padding(2)
                            Text("More\nInformation")
                        }
                        .frame(maxHeight: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color.orange)
                    .frame(width: UIScreen.main.bounds.width / 4)
                }
            }
            .frame(height: UIScreen.main.bounds.height * 0.1)
            .padding(0.0)
        }
        .frame(width: UIScreen.main.bounds.width)
        .presentationDetents([.fraction(0.33)])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled)
        .onAppear {
            Task {
                location.address = await viewModel.address(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
            }
        }
    }
}

#Preview {
    let laneStadium = CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804)
    let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
    let laneStadiumDestination = Destination(laneStadiumItem)

    LocationInfoView(location: laneStadiumDestination)
        .environment(SearchableMapViewModel())
}

