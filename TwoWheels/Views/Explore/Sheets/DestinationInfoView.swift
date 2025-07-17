//
//  DestinationInfoView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/1/24.
//

import MapKit
import SwiftData
import SwiftUI

struct DestinationInfoView: View {
    @State private var viewModel: DestinationInfoViewModel

    private let destination: Destination
    private let isPin: Bool
    private let isSaved: Bool

    init(
        destination: Destination,
        isPin: Bool,
        isSaved: Bool,
        onEdit: @escaping () -> Void,
        onUnPin: @escaping () -> Void
    ) {
        self.destination = destination
        self.isPin = isPin
        self.isSaved = isSaved
        _viewModel = State(initialValue: DestinationInfoViewModel(
            directionsService: DirectionsService {
                MKDirections(request: $0)
            } updates: {
                CLLocationUpdate.liveUpdates()
            },
            onEdit: onEdit,
            onUnPin: onUnPin
        ))
    }

    var body: some View {
        VStack() {
            VStack(alignment: .leading) {
                Text(destination.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text(destination.address)
                    .font(.title2)
                    .multilineTextAlignment(.leading)
            }
            .padding()
            
            HStack(alignment: .center, spacing: 10.0) {
                Button {
                    Task {
                        await viewModel.showDirections(to: destination)
                    }
                } label: {
                    VStack {
                        Image(systemName: "road.lanes.curved.right")
                            .padding(2)
                        Text("Get Directions")
                    }
                    .frame(maxHeight: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(.blue)
                .frame(width: UIScreen.main.bounds.width / 4)
                
                Button {
                    viewModel.edit()
                } label: {
                    VStack {
                        Image(systemName: isSaved ? "pencil" : "plus.circle")
                            .padding(2)
                        Text(isSaved ? "Edit Destination" : "Add Destination")
                    }
                    .frame(maxHeight: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(isSaved ? .yellow : .green)
                .frame(width: UIScreen.main.bounds.width / 4)
                
                if let url = destination.url {
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
                    .tint(.orange)
                    .frame(width: UIScreen.main.bounds.width / 4)
                }
                
                if isPin {
                    Button {
                        viewModel.removePin()
                    } label: {
                        VStack {
                            Image(systemName: "trash")
                                .padding(2)
                            Text("Delete Pin")
                        }
                        .frame(maxHeight: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.red)
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
        .sheet(isPresented: $viewModel.isDirectionsSheetPresented) {
            if let route = viewModel.route {
                DirectionsOverviewView(route: route)
            }
        }
        .alert("Directions Unavailable", isPresented: $viewModel.isDirectionsAlertPresented) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    let laneStadiumDestination = Destination(latitude: 38.22001, longitude: -81.41804, title: "Lane Stadium")

    return DestinationInfoView(destination: laneStadiumDestination, isPin: false, isSaved: false) {} onUnPin: {}
}

