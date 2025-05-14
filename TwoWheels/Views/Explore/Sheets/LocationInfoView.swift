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
    @Environment(ExploreViewModel.self) var viewModel
    
    let location: Destination
    
    var saved: Bool {
        viewModel.destinations.contains(location)
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
                    viewModel.editingDestination = location
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
                location.address = await viewModel.addressFromLocation(CLLocation(latitude: location.latitude, longitude: location.longitude))
            }
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: Destination.self, configurations: config)
    let laneStadiumDestination = Destination(latitude: 38.22001, longitude: -81.41804, title: "Lane Stadium")
    let dataService = DataService<Destination>(modelContext: container.mainContext)

    LocationInfoView(location: laneStadiumDestination)
        .environment(ExploreViewModel(dataService: dataService, searchService: SearchService(), geocoder: CLGeocoder()))
        .modelContainer(container)
}

