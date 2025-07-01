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
    let directions: (MKDirections.Request) -> MKDirections
    let updates: () -> any AsyncSequence
    
    init(
        directions: @escaping (MKDirections.Request) -> MKDirections,
        updates: @escaping () -> any AsyncSequence
    ) {
        self.directions = directions
        self.updates = updates
    }
    
    func getDirections(with request: MKDirections.Request) async throws -> MKRoute? {
        let directions = directions(request)
        let response = try await directions.calculate()
        return response.routes.first
    }
    
    func getUserMapItem() async throws -> MKMapItem? {
        let updates = self.updates()
        
        do {
            let userLocation = try await updates.first { update in
                if let location = update as? Locatable,
                      location.location != nil {
                    return true
                }
                return false
            }
            if let location = userLocation as? Locatable {
                return makeMapItem(from: location)
            }
        } catch {
            print("failed to get user location with error: \(error)")
        }
        return nil
    }
    
    private func makeMapItem(from location: Locatable) -> MKMapItem? {
        guard let coordinate = location.location?.coordinate else { return nil }
        let placemark = MKPlacemark(coordinate: coordinate)
        return MKMapItem(placemark: placemark)
    }
}

protocol Locatable {
    var location: CLLocation? { get }
}

extension CLLocationUpdate: Locatable {}
