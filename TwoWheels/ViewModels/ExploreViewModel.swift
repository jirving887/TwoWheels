//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
import MapKit

@Observable
class ExploreViewModel: NSObject, MKLocalSearchCompleterDelegate {
    private let dataService: any DataManupilating<Destination>
    private let mapService: MapSearchingProtocol
    
    let completer = MKLocalSearchCompleter()
    var destinations: [Destination] = []
    var searchCompletions: [MKLocalSearchCompletion] = []
    var searchResults: [Destination] = []
    var selectedTab: TabSelection = .map
    var visibleRegion = MKCoordinateRegion.init()
    
    var searchString: String = "" {
        didSet {
            searchStringUpdated()
        }
    }
    
    init(dataService: any DataManupilating<Destination>, mapService: MapSearchingProtocol) {
        self.dataService = dataService
        self.mapService = mapService
        destinations = dataService.fetch()
        super.init()
        completer.delegate = self
    }
    
    func addDestination(_ destination: Destination) {
        dataService.add(destination)
        destinations = dataService.fetch()
    }
    
    func deleteDestination(_ destination: Destination) {
        dataService.remove(destination)
        destinations = dataService.fetch()
    }
    
    func search() {
        guard !searchString.isEmpty else {
            searchResults = []
            return
        }
        
        searchResults = mapService.search(for: searchString, in: visibleRegion).compactMap { Destination($0) }
    }
    
    func search(with completion: MKLocalSearchCompletion) {
        searchResults = mapService.search(with: completion, in: visibleRegion).compactMap { Destination($0) }
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
    
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        searchCompletions = completer.results
    }
}
