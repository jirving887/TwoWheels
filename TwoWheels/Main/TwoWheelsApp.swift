//
//  TwoWheelsApp.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/5/24.
//

import SwiftUI
import SwiftData

struct TwoWheelsApp: App {
    
    @State private var selectedTab: TabSelection = .map
    
    var body: some Scene {
        WindowGroup {
            TabView(selection: $selectedTab) {
                Tab("Map", systemImage: "map", value: .map) {
                    SearchableMapView()
                }
                
                Tab("Destinations", systemImage: "list.bullet", value: .list) {
                    DestinationsListView()
                }
            }
        }
        .modelContainer(for: [Destination.self])
    }
}
