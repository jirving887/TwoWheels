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
                SearchableMapView()
        }
        .modelContainer(for: Destination.self)
    }
}
