//
//  TwoWheelsApp.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/5/24.
//

import SwiftUI

@main
struct TwoWheelsApp: App {
    
    @StateObject var destinations = Destinations()
    
    var body: some Scene {
        WindowGroup {
            TabView {
                MapView()
                    .tabItem {
                        Image(systemName: "map")
                        Text("Map")
                    }
                SearchableMapView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("Search Map")
                    }
//                WeatherView()
//                    .tabItem {
//                        Image(systemName: "sun.max")
//                        Text("Weather")
//                    }
//                ProfileView()
//                    .tabItem {
//                        Image(systemName: "person")
//                        Text("Profile")
//                    }
            }
            .environmentObject(destinations)
        }
    }
}
