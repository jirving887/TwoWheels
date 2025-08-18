//
//  SearchCompleter.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/18/25.
//

import Foundation
import MapKit

protocol SearchCompleting: MKLocalSearchCompleterDelegate {
    func update(region: MKCoordinateRegion)
    func update(queryFragment: String)
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter)
}

class SearchCompleter: NSObject, SearchCompleting {
    let completer: MKLocalSearchCompleter

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }

    func update(region: MKCoordinateRegion) {
        completer.region = region
    }

    func update(queryFragment: String) {}

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {}
}
