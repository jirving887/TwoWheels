//
//  SearchCompleterSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 8/18/25.
//

import Foundation
import MapKit
@testable import TwoWheels

class SearchCompleterSpy: NSObject, SearchCompleting {
    var queryFragment = ""
    var region = MKCoordinateRegion()

    func update(region: MKCoordinateRegion) {
        self.region = region
    }

    func update(queryFragment: String) {
        self.queryFragment = queryFragment
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {}
}
