//
//  LocationInfoView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/1/24.
//

import MapKit
import SwiftUI

struct LocationInfoView: View {
    
    let location: MKMapItem
    
    var name: String {
        return location.name ?? "No Name"
    }
    
    var title: String {
        return location.placemark.title ?? "No Title"
    }
    
    var url: URL? {
        return location.url
    }
    
    var body: some View {
        VStack() {
            VStack(alignment: .leading) {
                Text(name)
                    .font(.title)
                    .fontWeight(.bold)
                    .multilineTextAlignment(.leading)
                Text(location.placemark.title ?? "No Title")
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
                    // TODO: Implement destination addition
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
                
                if let url {
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
    }
}

#Preview {
    LocationInfoView(location: .init(placemark: .init(coordinate: .init(latitude: 40.7127636, longitude: -74.00598))))
}

