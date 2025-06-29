//
//  DirectionsService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/17/25.
//

import MapKit

protocol Directing {
    func getDirections(with request: MKDirections.Request) async throws -> MKRoute?
    func getUserMapItem() async throws -> MKMapItem?
}

class DirectionsService: Directing {
    let makeMKDirections: (MKDirections.Request) -> MKDirections
    
    init(makeMKDirections: @escaping (MKDirections.Request) -> MKDirections) {
        self.makeMKDirections = makeMKDirections
    }
    
    func getDirections(with request: MKDirections.Request) async throws -> MKRoute? {
        let directions = makeMKDirections(request)
        let response = try await directions.calculate()
        return response.routes.first
    }
    
    func getUserMapItem() async throws -> MKMapItem? {
        .init()
    }
}


