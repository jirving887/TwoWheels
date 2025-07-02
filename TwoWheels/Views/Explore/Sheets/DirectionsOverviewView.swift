//
//  DirectionsOverviewView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/17/25.
//

import MapKit
import SwiftData
import SwiftUI

struct DirectionsOverviewView: View {
    @Environment(ExploreViewModel.self) var viewModel
    
    var body: some View {
        VStack {
            Map() {
                if let route = viewModel.route {
                    MapPolyline(route)
                        .stroke(.blue, style: StrokeStyle(
                                lineWidth: 5,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )
                }
            }
            .cornerRadius(20)
            
            HStack {
                VStack {
                    Text("Distance:")
                        .font(.headline)
                    Text(viewModel.routeDistance)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red)
                .cornerRadius(20)
                
                VStack {
                    Text("Time:")
                        .font(.headline)
                    Text(viewModel.routeTime)
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.orange)
                .cornerRadius(20)
                
                VStack {
                    Text("ETA:")
                        .font(.headline)
                    Text(viewModel.eta)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.yellow)
                .cornerRadius(20)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.1)
            
            Button {
                viewModel.startNavigation()
            } label: {
                Text("Go")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .frame(maxWidth: .infinity)
            .frame(height: UIScreen.main.bounds.height * 0.1)
        }
        .padding()
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
    
    viewModel.routeDistance = "80.00 mi"
    viewModel.routeTime = "10d, 23h, 59m"
    viewModel.eta = "11:59 PM"
    
    return DirectionsOverviewView()
        .environment(viewModel)
}
