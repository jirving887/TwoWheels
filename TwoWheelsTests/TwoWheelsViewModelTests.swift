//
//  TwoWheelsViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/18/25.
//

import Testing
@testable import TwoWheels

struct TwoWheelsViewModelTests {

    @Test
    func init_shouldBeInExploreMode() {
        let sut = TwoWheelsViewModel()

        #expect(sut.mode == .exploring)
    }

    @Test
    func navigate_shouldSetModeToNavigating() {
        let sut = TwoWheelsViewModel()

        sut.navigate()

        #expect(sut.mode == .navigating)
    }

}
