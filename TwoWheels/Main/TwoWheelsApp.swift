//
//  TwoWheelsApp.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/5/24.
//

import SwiftUI
import SwiftData

struct TwoWheelsApp: App {
    let container: ModelContainer
    
    init() {
        do {
            container = try ModelContainer(for: Destination.self)
        } catch {
            fatalError("Failed to create ModelContainer for Destination.")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            ExploreView(modelContainer: container)
        }
    }
}
