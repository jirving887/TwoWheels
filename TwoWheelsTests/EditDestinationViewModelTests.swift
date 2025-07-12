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

    @Test
    func init_withDestination_shouldHaveInfo() {
        let laneStadiumDestination = Destination(
            latitude: 37.22001,
            longitude: -80.41804,
            title: "Lane Stadium"
        )
        
        let sut = EditDestinationViewModel(destination: laneStadiumDestination)

        #expect(sut.originalTitle == laneStadiumDestination.title)
        #expect(sut.originalAddress == laneStadiumDestination.address)
        #expect(sut.title == laneStadiumDestination.title)
        #expect(sut.address == laneStadiumDestination.address)
    }

}
