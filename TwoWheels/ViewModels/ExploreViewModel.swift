//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
import MapKit

@Observable
class ExploreViewModel {
    private let dataService: any DataManupilating<Destination>
    private let searchService: MapSearching
    
    let completer = MKLocalSearchCompleter()
    var destinations: [Destination] = []
    var searchCompletions: [MKLocalSearchCompletion] {
        get {
            completer.results
        } set {}
    }
    var searchResults: [Destination] = []
    var selectedTab: TabSelection = .map
    var visibleRegion = MKCoordinateRegion.init()
    
    var searchString: String = "" {
        didSet {
            searchStringUpdated()
        }
    }
    
    init(dataService: any DataManupilating<Destination>, searchService: MapSearching) {
        self.dataService = dataService
        self.searchService = searchService
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
    
    func search() async {
        guard !searchString.isEmpty else {
            searchResults = []
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchString
        request.region = visibleRegion
        await search(request)
    }
    
    func search(with completion: MKLocalSearchCompletion) async {
        let request = MKLocalSearch.Request(completion: completion)
        await search(request)
    }
    
    func searchStringUpdated() {
        guard !searchString.isEmpty else {
            searchCompletions = []
            return
        }
        if searchString.count == 1 {
            completer.region = visibleRegion
        }
        completer.queryFragment = searchString
    }
    
    private func search(_ request: MKLocalSearch.Request) async {
        do {
            searchResults = try await searchService.search(with: request).compactMap {
                Destination($0)
            }
        } catch {
            searchResults = []
        }
    }
}
