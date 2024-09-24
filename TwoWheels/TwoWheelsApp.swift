//
//  TwoWheelsApp.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/5/24.
//

import SwiftUI
import SwiftData

@main
struct TwoWheelsApp: App {
    
    var body: some Scene {
        WindowGroup {
            TabView {
                Group {
                    SearchableMapView()
                        .tabItem {
                            Label("Map", systemImage: "map")
                        }
                    
                    DestinationsListView()
                        .tabItem {
                            Label("Destinations", systemImage: "list.bullet")
                        }
                }
            }
        }
        .modelContainer(for: [Destination.self])
    }
}
