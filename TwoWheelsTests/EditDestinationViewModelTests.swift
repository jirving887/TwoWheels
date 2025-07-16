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
    let laneStadiumDestination: Destination

    init() {
        laneStadiumDestination = Destination(
            latitude: 37.22001,
            longitude: -80.41804,
            title: "Lane Stadium"
        )
    }

    @Test
    func init_withDestination_shouldHaveInfo() {
        let sut = makeSUT()

        #expect(sut.title == laneStadiumDestination.title)
        #expect(sut.address == laneStadiumDestination.address)
    }

    @Test
    func init_shouldNotShowAlert() {
        let sut = makeSUT()

        #expect(!sut.isShowingEmptyTitleAlert)
    }

    @Test
    func saveDestinaton_withEmptyTitle_shouldShowAlert() {
        var dismissed = false
        let sut = makeSUT()
        sut.title = ""

        sut.saveDestination {
            dismissed = true
        }

        #expect(sut.isShowingEmptyTitleAlert)
        #expect(!dismissed)
    }

    @Test
    func saveDestination_withNonEmptyTitle_shouldSaveDestination() {
        var dismissed = false
        var destinations: [Destination] = []
        let sut = makeSUT() { destinations.append($0) }
        sut.title = "New Title"
        sut.address = "New Address"

        sut.saveDestination {
            dismissed = true
        }

        #expect(destinations.count == 1)
        #expect(destinations.first?.title == "New Title")
        #expect(destinations.first?.address == "New Address")
        #expect(dismissed)
    }

    @Test
    func saveDestination_withExistingDestination_shouldUpdateDestination() {
        var dismissed = false
        let sut = makeSUT(isSaved: true)
        sut.title = "Lane Stadium 2"

        sut.saveDestination {
            dismissed = true
        }

        #expect(laneStadiumDestination.title == "Lane Stadium 2")
        #expect(dismissed)
    }

    // MARK: Helpers

    func makeSUT(isSaved: Bool = false, onSave: @escaping (Destination) -> Void = { _ in }) -> EditDestinationViewModel {
        EditDestinationViewModel(destination: laneStadiumDestination, isSaved: isSaved, onSave: onSave)
    }
}
