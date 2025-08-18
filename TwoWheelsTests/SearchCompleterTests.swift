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
        let sut = SearchCompleter(completer: completer)

        #expect(sut.completer == completer)
    }

    @Test
    func updateRegion_shouldUpdateCompleterRegion() {
        let completer = MKLocalSearchCompleter()
        let sut = SearchCompleter(completer: completer)
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804),
            latitudinalMeters: 10,
            longitudinalMeters: 10
        )

        sut.update(region: region)

        #expect(completer.region == region)
    }

}
