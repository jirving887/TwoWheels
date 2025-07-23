//
//  NavigationView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 7/2/25.
//

import MapKit
import SwiftUI

struct NavigationView: View {
    @Environment(TwoWheelsViewModel.self) var twoWheelsViewModel

    @State private var position = MapCameraPosition.userLocation(fallback: .automatic)
    @State private var bounds = MapCameraBounds(minimumDistance: 500, maximumDistance: 1000)
    let route: MKRoute

    var body: some View {
        Map(position: $position, bounds: bounds, interactionModes: [.zoom, .pitch]) {
            MapPolyline(route)
                .stroke(.blue, style:
                            StrokeStyle(
                                lineWidth: 5,
                                lineCap: .round,
                                lineJoin: .round
                            )
                        )

            UserAnnotation {
                ZStack {
                    Circle()
                        .fill(.blue)

                    Image(systemName: "motorcycle.fill")
                        .foregroundStyle(.white)
                        .padding(10)
                }
            }
        }
        .overlay(alignment: .bottom) {
            Button {
                twoWheelsViewModel.endNavigation()
            } label: {
                Text("End Navigation")
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.red)
            .frame(maxWidth: .infinity, maxHeight: 100)
            .cornerRadius(50)
            .padding()
        }
        .overlay(alignment: .top) {
            ZStack {
                Color(.gray)
                    .opacity(0.3)

                VStack(alignment: .leading) {
                    HStack {
                        ForEach(0..<3) { _ in
                            ZStack {
                                RoundedRectangle(cornerRadius: 35)
                                    .foregroundStyle(.gray.opacity(0.3))
                                    .frame(maxHeight: 100)

                                Text("info")
                            }
                        }
                    }

                    HStack {
                        Image(systemName: "arrow.turn.up.left")
                            .resizable()
                            .scaledToFit()

                        Text("Directions")
                    }
                    .frame(maxHeight: .infinity)
                }
                .padding()
            }
            .frame(maxHeight: 175)
            .cornerRadius(50)
            .padding(.horizontal)
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    NavigationView(route: .init())
        .environment(TwoWheelsViewModel())
}
