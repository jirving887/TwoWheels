//
//  SearchCompleter.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/18/25.
//

import Foundation
import MapKit

protocol SearchCompleting: MKLocalSearchCompleterDelegate {
    var didUpdateCompletions: (([MKLocalSearchCompletion]) -> Void)? { get set }
    func update(region: MKCoordinateRegion)
    func update(queryFragment: String)
    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter)
}

class SearchCompleter: NSObject, SearchCompleting {
    var didUpdateCompletions: (([MKLocalSearchCompletion]) -> Void)?
    let completer: MKLocalSearchCompleter

    init(completer: MKLocalSearchCompleter) {
        self.completer = completer
        super.init()
        self.completer.delegate = self
    }

    func update(region: MKCoordinateRegion) {
        completer.region = region
    }

    func update(queryFragment: String) {
        completer.queryFragment = queryFragment
    }

    func completerDidUpdateResults(_ completer: MKLocalSearchCompleter) {
        guard let didUpdateCompletions else { return }
        didUpdateCompletions(completer.results)
    }
}
