//
//  MapSearchService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/25.
//

import MapKit

protocol MapSearching {
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem]
}

class SearchService: MapSearching {
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem] {
        let search = makeLocalSearch(request)
        let response = try await search.start()
        
        return response.mapItems
    }
    
    func makeLocalSearch(_ request: MKLocalSearch.Request) -> MKLocalSearch {
        return MKLocalSearch(request: request)
    }

}
