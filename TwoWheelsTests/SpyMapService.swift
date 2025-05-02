//
//  SpyMapService.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 4/29/25.
//

import Foundation
import MapKit
@testable import TwoWheels

class SpyMapService: MapSearchingProtocol {
    var expectedSearchResults: [MKMapItem] = []
    
    func search(_ searchString: String) -> [MKMapItem] {
        expectedSearchResults
    }
}
