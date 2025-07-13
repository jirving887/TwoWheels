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
    let dataServiceSpy: DataServiceSpy
    let destination: Destination

    init() {
        dataServiceSpy = DataServiceSpy()
        destination = Destination(
            latitude: 37.22001,
            longitude: -80.41804,
            title: "Lane Stadium"
        )
    }

    @Test
    func init_withDestination_shouldHaveInfo() {
        let sut = makeSUT()

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

    @Test
    func saveDestination_withNonEmptyTitle_shouldSaveDestination() {
        let sut = makeSUT()
        sut.title = "New Title"
        sut.address = "New Address"

        sut.saveDestination()

        #expect(dataServiceSpy.destinations.count == 1)
        #expect(dataServiceSpy.destinations.first?.title == "New Title")
        #expect(dataServiceSpy.destinations.first?.address == "New Address")
    }

    @Test
    func saveDestination_withExistingDestination_shouldUpdateDestination() {
        dataServiceSpy.destinations = [destination]
        let sut = makeSUT()
        sut.title = "Lane Stadium 2"

        sut.saveDestination()

        #expect(dataServiceSpy.destinations.count == 1)
        #expect(dataServiceSpy.destinations.first?.title == "Lane Stadium 2")
        #expect(destination.title == "Lane Stadium 2")
    }

    // MARK: Helpers

    func makeSUT() -> EditDestinationViewModel {
        EditDestinationViewModel(destination: destination, dataService: dataServiceSpy)
    }
}
