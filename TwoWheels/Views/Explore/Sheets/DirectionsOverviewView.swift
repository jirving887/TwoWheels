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
    @Environment(ExploreViewModel.self) var twoWheelsViewModel

    private let viewModel = DirectionsOverviewViewModel()

    let route: MKRoute

    var body: some View {
        VStack {
            Map {
                MapPolyline(route)
                    .stroke(.blue, style: StrokeStyle(
                            lineWidth: 5,
                            lineCap: .round,
                            lineJoin: .round
                        )
                    )
            }
            .cornerRadius(20)

            HStack {
                VStack {
                    Text("Distance:")
                        .font(.headline)
                    Text(viewModel.calculateDistance(with: route.distance))
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.red.opacity(0.3))
                .cornerRadius(20)

                VStack {
                    Text("Time:")
                        .font(.headline)
                    Text(viewModel.calculateTime(with: route.expectedTravelTime))
                        .lineLimit(1)
                        .minimumScaleFactor(0.01)
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.orange.opacity(0.3))
                .cornerRadius(20)

                VStack {
                    Text("ETA:")
                        .font(.headline)
                    Text(viewModel.calculateEta(with: route.expectedTravelTime))
                }
                .padding()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .background(.yellow.opacity(0.3))
                .cornerRadius(20)
            }
            .fixedSize(horizontal: false, vertical: true)
            .frame(maxHeight: UIScreen.main.bounds.height * 0.1)

            Button {
                twoWheelsViewModel.startNavigation()
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

    let dataService = DataService<Destination>(modelContainer: container)
    let exploreViewModel = ExploreViewModel(
        dataService: dataService,
        geocoder: CLGeocoder()
    )

    return DirectionsOverviewView(route: .init())
        .environment(exploreViewModel)
}
