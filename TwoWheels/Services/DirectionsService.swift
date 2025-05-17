//
//  DirectionsService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/17/25.
//

import MapKit

protocol Directing {
    func getDirections(with request: MKDirections.Request) async throws -> MKRoute
    func getUserMapItem() async throws -> MKMapItem
}

class DirectionsService: Directing {
    func getDirections(with request: MKDirections.Request) async throws -> MKRoute {
        .init()
    }
    
    func getUserMapItem() async throws -> MKMapItem {
        .init()
    }
}


