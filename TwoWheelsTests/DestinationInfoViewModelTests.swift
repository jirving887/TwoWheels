//
//  DestinationInfoViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/14/25.
//

import Foundation
import Testing
@testable import TwoWheels

@MainActor
struct DestinationInfoViewModelTests {
    let directionsServiceSpy: DirectionsServiceSpy
    let laneStadiumDestination: Destination

    init() {
        directionsServiceSpy = DirectionsServiceSpy()
        laneStadiumDestination = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium")
    }

    @Test
    func init_shouldNotShowModals() {
        let sut = makeSUT()

        #expect(!sut.isDirectionsSheetPresented)
        #expect(!sut.isDirectionsAlertPresented)
    }

    @Test
    func showDirections_onSuccess_shouldGetAndDisplayDirections() async {
        let sut = makeSUT()
        sut.isDirectionsAlertPresented = true
        sut.isDirectionsSheetPresented = false

        await sut.showDirections(to: laneStadiumDestination)

        #expect(sut.route != nil)
        #expect(sut.isDirectionsSheetPresented)
        #expect(!sut.isDirectionsAlertPresented)
    }

    @Test
    func showDirections_withDirectionsError_shouldShowAlert() async {
        directionsServiceSpy.directionsError = NSError(domain: "", code: 0, userInfo: nil)
        let sut = makeSUT()
        sut.isDirectionsAlertPresented = false
        sut.isDirectionsSheetPresented = true

        await sut.showDirections(to: laneStadiumDestination)

        #expect(directionsServiceSpy.errorCount == 1)
        #expect(sut.isDirectionsAlertPresented)
        #expect(!sut.isDirectionsSheetPresented)

    }

    @Test
    func showDirections_withLocationError_shouldShowAlert() async {
        directionsServiceSpy.locationError = NSError(domain: "", code: 0, userInfo: nil)
        let sut = makeSUT()
        sut.isDirectionsAlertPresented = false
        sut.isDirectionsSheetPresented = true

        await sut.showDirections(to: laneStadiumDestination)

        #expect(directionsServiceSpy.errorCount == 1)
        #expect(sut.isDirectionsAlertPresented)
        #expect(!sut.isDirectionsSheetPresented)

    }

    @Test
    func edit_callsEditClosure() {
        var editing = false
        let sut = makeSUT {
            editing = true
        }

        sut.edit()

        #expect(editing)
    }

    @Test
    func removePin_callsUnPinClosure() {
        var destinations = [laneStadiumDestination]
        let sut = makeSUT {} onUnPin: {
            destinations.removeAll(where: { $0 == laneStadiumDestination })
        }

        sut.removePin()

        #expect(destinations.isEmpty)
    }

    // MARK: Helpers

    private func makeSUT(onEdit: @escaping () -> Void = {}, onUnPin: @escaping () -> Void = {}) -> DestinationInfoViewModel {
        DestinationInfoViewModel(
            directionsService: directionsServiceSpy,
            onEdit: onEdit,
            onUnPin: onUnPin
        )
    }
}
