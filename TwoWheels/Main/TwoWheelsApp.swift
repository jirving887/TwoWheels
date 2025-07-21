//
//  TwoWheelsApp.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/5/24.
//

import SwiftUI
import SwiftData

struct TwoWheelsApp: App {
    @State private var twoWheelsViewModel = TwoWheelsViewModel()

    private let dataService: any DataManipulating<Destination>

    init() {
        let container: ModelContainer
        do {
            container = try ModelContainer(for: Destination.self)
        } catch {
            fatalError("Failed to create ModelContainer for Destination.")
        }
        dataService = DataService(modelContainer: container)
    }

    var body: some Scene {
        WindowGroup {
            if let route = twoWheelsViewModel.route {
                NavigationView(route: route)
            } else {
                ExploreView(dataService: dataService)
            }
        }
        .environment(twoWheelsViewModel)
    }
}
