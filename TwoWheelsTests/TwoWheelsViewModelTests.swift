//
//  TwoWheelsViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/18/25.
//

import MapKit
import Testing
@testable import TwoWheels

struct TwoWheelsViewModelTests {

    @Test
    func init_shouldBeInExploreMode() {
        let sut = TwoWheelsViewModel()

        #expect(sut.route == nil)
    }

    @Test
    func navigate_shouldSetRoute() {
        let sut = TwoWheelsViewModel()
        let route = MKRoute()

        sut.navigate(route: route)

        #expect(sut.route == route)
    }
}
