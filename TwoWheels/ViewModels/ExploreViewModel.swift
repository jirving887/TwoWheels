//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation

@Observable
class ExploreViewModel {
    private let dataService: DataService
    
    var selectedTab: TabSelection = .map
    var destinations: [Destination] = []
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
    
    func addDestination(_ destination: Destination) {
        dataService.add(destination)
        destinations = dataService.fetch()
    }
    
    func deleteDestination(_ destination: Destination) {
        dataService.remove(destination)
        destinations = dataService.fetch()
    }
}
