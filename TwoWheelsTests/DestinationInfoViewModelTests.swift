//
//  DestinationInfoViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/14/25.
//

import Testing
@testable import TwoWheels

@MainActor
struct DestinationInfoViewModelTests {

    @Test
    func init_shouldNotShowModals() {
        let sut = DestinationInfoViewModel()

        #expect(!sut.isDirectionsSheetPresented)
        #expect(!sut.isDirectionsAlertPresented)
    }

}
