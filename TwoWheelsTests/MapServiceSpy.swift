//
//  MapServiceSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 4/29/25.
//

import Foundation
import MapKit
@testable import TwoWheels

class MapServiceSpy: NSObject, MapSearchingProtocol {
    var expectedSearchResults: [MKMapItem] = []
    var expectedSearchCompletions: [MKLocalSearchCompletion] = []
    
    func search(_ searchString: String) -> [MKMapItem] {
        expectedSearchResults
    }
    
    func search(_ completion: MKLocalSearchCompletion) -> [MKMapItem] {
        expectedSearchResults
    }

    func updateCompletions(with searchString: String) -> [MKLocalSearchCompletion] {
        expectedSearchCompletions
    }
}
