//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation

@Observable
class ExploreViewModel {
    private let dataService: any DataManupilating<Destination>
    private let mapService: MapSearchingProtocol
    
    var destinations: [Destination]
    var searchResults: [Destination] = []
    var selectedTab: TabSelection = .map
    
    init(dataService: any DataManupilating<Destination>, mapService: MapSearchingProtocol) {
        self.dataService = dataService
        self.mapService = mapService
        destinations = dataService.fetch()
    }
    
    func addDestination(_ destination: Destination) {
        dataService.add(destination)
        destinations = dataService.fetch()
    }
    
    func deleteDestination(_ destination: Destination) {
        dataService.remove(destination)
        destinations = dataService.fetch()
    }
    
    func search(with searchString: String) {
        guard !searchString.isEmpty else {
            searchResults = []
            return
        }
        
        searchResults = mapService.search(searchString).compactMap { Destination($0) }
    }
}
