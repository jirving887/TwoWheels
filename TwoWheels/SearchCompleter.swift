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
    private let didUpdateCompletions: ([MKLocalSearchCompletion]) -> Void
    let completer: MKLocalSearchCompleter

    init(completer: MKLocalSearchCompleter, didUpdateCompletions: @escaping ([MKLocalSearchCompletion]) -> Void) {
        self.completer = completer
        self.didUpdateCompletions = didUpdateCompletions
        super.init()
        self.completer.delegate = self
    }

    func update(region: MKCoordinateRegion) {
        completer.region = region
    }

    func update(queryFragment: String) {
        completer.queryFragment = queryFragment
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {}
}
