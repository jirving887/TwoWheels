//
//  EditDestinationViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/12/25.
//

import Testing
@testable import TwoWheels

@MainActor
struct EditDestinationViewModelTests {
    let destination: Destination

    init() {
        destination = Destination(
            latitude: 37.22001,
            longitude: -80.41804,
            title: "Lane Stadium"
        )
    }

    @Test
    func init_withDestination_shouldHaveInfo() {
        let sut = makeSUT()

        #expect(sut.originalTitle == destination.title)
        #expect(sut.originalAddress == destination.address)
        #expect(sut.title == destination.title)
        #expect(sut.address == destination.address)
    }

    @Test
    func init_shouldNotShowAlert() {
        let sut = makeSUT()

        #expect(!sut.isShowingEmptyTitleAlert)
    }

    @Test
    func saveDestinaton_withEmptyTitle_shouldShowAlert() {
        let sut = makeSUT()
        sut.title = ""

        sut.saveDestination()

        #expect(sut.isShowingEmptyTitleAlert)
    }

    // MARK: Helpers

    func makeSUT() -> EditDestinationViewModel {
        EditDestinationViewModel(destination: destination)
    }
}
