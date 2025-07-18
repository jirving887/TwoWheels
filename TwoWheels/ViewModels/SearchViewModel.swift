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
    private let onSearchComplete: ([Destination]) -> Void

    let completer = MKLocalSearchCompleter()
    var searchResults: [Destination] = []

    var searchCompletions: [MKLocalSearchCompletion] {
        completer.results
    }

    var searchString = "" {
        didSet {
            searchStringUpdated()
        }
    }

    init(
        region: MKCoordinateRegion,
        searchService: any MapSearching,
        onSearchComplete: @escaping ([Destination]) -> Void
    ) {
        self.region = region
        self.searchService = searchService
        self.onSearchComplete = onSearchComplete
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
        onSearchComplete(searchResults)
    }

    private func searchStringUpdated() {
        guard !searchString.isEmpty else {
            completer.queryFragment = ""
            completer.resultTypes = []
            return
        }
        if searchString.count == 1 {
            completer.region = region
        }
        completer.queryFragment = searchString
    }
}
