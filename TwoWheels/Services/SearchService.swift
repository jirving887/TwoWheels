//
//  MapSearchService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/25.
//

import MapKit

protocol MapSearching: Sendable {
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem]
}

class SearchService: MapSearching, @unchecked Sendable {
    let makeLocalSearch: (MKLocalSearch.Request) -> MKLocalSearch
    
    init(makeLocalSearch: @escaping (MKLocalSearch.Request) -> MKLocalSearch) {
        self.makeLocalSearch = makeLocalSearch
    }
    
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        let search = makeLocalSearch(request)
        let response = try await search.start()
        
        return response.mapItems
    }
}
