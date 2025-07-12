//
//  SearchViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 7/12/25.
//

import Foundation
import MapKit

@MainActor
@Observable
class SearchViewModel {
    private let searchService: any MapSearching
    private let region: MKCoordinateRegion

    var searchResults: [Destination] = []
    var searchString = ""

    init(region: MKCoordinateRegion, searchService: any MapSearching) {
        self.region = region
        self.searchService = searchService
    }

    func search() async {
        guard !searchString.isEmpty else {
            searchResults = []
            return
        }
        let request = MKLocalSearch.Request()
        request.naturalLanguageQuery = searchString
        request.region = region
        await search(request)
    }
    
    func search(with completion: MKLocalSearchCompletion) async {
        let request = MKLocalSearch.Request(completion: completion)
        await search(request)
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
