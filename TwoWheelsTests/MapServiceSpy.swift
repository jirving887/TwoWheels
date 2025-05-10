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
    var searchRegion: MKCoordinateRegion?
    
    func search(for searchString: String, in region: MKCoordinateRegion) -> [MKMapItem] {
        expectedSearchResults
    }
    
    func search(with completion: MKLocalSearchCompletion) -> [MKMapItem] {
        expectedSearchResults
    }
}
