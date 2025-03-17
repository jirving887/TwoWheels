//
//  MapSearchable.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 3/16/25.
//

import MapKit

protocol MapSearchable {
    
    func search(with request: MKLocalSearch.Request) async throws -> [MKMapItem]
    
    func address(from location: CLLocation) async throws -> [CLPlacemark]
}
