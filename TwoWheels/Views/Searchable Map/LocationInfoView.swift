//
//  LocationInfoView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/1/24.
//

import MapKit
import SwiftUI

struct LocationInfoView: View {
    @Environment(\.modelContext) var modelContext
    
    let location: Destination
    let mapService = MapService(completer: MKLocalSearchCompleter())
    @State private var address = ""
    
    var body: some View {
        VStack() {
            VStack(alignment: .leading) {
                Text(location.title)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text(address)
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
                    modelContext.insert(location)
                } label: {
                    VStack {
                        Image(systemName: "plus.circle")
                            .padding(2)
                        Text("Add Destination")
                    }
                    .frame(maxHeight: .infinity)
                }
                .buttonStyle(.borderedProminent)
                .tint(Color.green)
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
                address = try await mapService.address(from: CLLocation(latitude: location.latitude, longitude: location.longitude))
            }
        }
    }
}

#Preview {
    LocationInfoView(location: .init(MKMapItem(placemark: .init(coordinate: .init(latitude: 40.7127636, longitude: -74.00598)))))
}

