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
                GroupBox {
                    Text("Distance: \(String(describing: viewModel.route?.distance))")
                }
                .tint(.blue)
                
                GroupBox {
                    Text("Travel Time: \(String(describing: viewModel.route?.expectedTravelTime))")
                }
                
                GroupBox {
                    Text("ETA: \(String(describing: Date().addingTimeInterval(TimeInterval(viewModel.route?.expectedTravelTime ?? 0))))")
                }
            }
            
            Button {
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
    
    return DirectionsOverviewView()
        .environment(viewModel)
}
