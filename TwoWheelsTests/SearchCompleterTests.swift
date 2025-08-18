//
//  SearchCompleterTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 8/18/25.
//

import MapKit
import Testing
@testable import TwoWheels

struct SearchCompleterTests {

    @Test
    func init_shouldSetCompleter() {
        let completer = MKLocalSearchCompleter()

        let sut = makeSUT(completer: completer)

        #expect(sut.completer == completer)
        #expect(sut.completer.delegate === sut)
    }

    @Test
    func updateRegion_shouldUpdateCompleterRegion() {
        let completer = MKLocalSearchCompleter()
        let sut = makeSUT(completer: completer)

        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804),
            latitudinalMeters: 10,
            longitudinalMeters: 10
        )

        sut.update(region: region)

        #expect(completer.region == region)
    }

    @Test
    func updateQueryFragment_shouldUpdateCompleterQueryFragment() {
        let completer = MKLocalSearchCompleter()
        let sut = makeSUT(completer: completer)

        sut.update(queryFragment: "Lane Stadium")

        #expect(completer.queryFragment == "Lane Stadium")
    }

    // MARK: Helpers

    func makeSUT(
        completer: MKLocalSearchCompleter,
        didUpdateCompletions: @escaping ([MKLocalSearchCompletion]) -> Void = { _ in }
    ) -> SearchCompleter {
        SearchCompleter(completer: completer, didUpdateCompletions: didUpdateCompletions)
    }

}
