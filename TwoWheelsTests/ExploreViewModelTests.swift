//
//  ExploreViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 4/28/25.
//

import MapKit
import Testing
@testable import TwoWheels
public import _MapKit_SwiftUI

@MainActor
struct ExploreViewModelTests {
    let dataServiceSpy: DataServiceSpy
    let geocoderSpy: GeocoderSpy
    let directionsServiceSpy: DirectionsServiceSpy
    let sut: ExploreViewModel
    let laneStadiumDestination: Destination
    let laneStadiumItem: MKMapItem
    let burrussHallDestination: Destination
    let burrussHallItem: MKMapItem

    init() {
        dataServiceSpy = DataServiceSpy()
        geocoderSpy = GeocoderSpy()
        directionsServiceSpy = DirectionsServiceSpy()
        sut = ExploreViewModel(
            dataService: dataServiceSpy,
            geocoder: geocoderSpy
        )
        laneStadiumDestination = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium")
        laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadiumDestination.coordinate))
        burrussHallDestination = Destination(latitude: 37.229000, longitude: -80.423710)
        burrussHallItem = MKMapItem(placemark: MKPlacemark(coordinate: burrussHallDestination.coordinate))
    }

    @Test
    func init_withNonEmptyDataService_shouldHaveData() {
        dataServiceSpy.destinations = [laneStadiumDestination]
        let freshSut = ExploreViewModel(
            dataService: dataServiceSpy,
            geocoder: geocoderSpy
        )
        #expect(freshSut.destinations == [laneStadiumDestination])
    }

    @Test
    func addDestination_shouldAddDestination() {
        sut.addDestination(laneStadiumDestination)

        #expect(dataServiceSpy.destinationTitles == ["Lane Stadium"])
        #expect(sut.destinations == dataServiceSpy.destinations)
    }

    @Test
    func deleteDestination_shouldDeleteDestination() {
        for num in 0..<3 {
            let newDestination = Destination(
                latitude: 38.22001,
                longitude: -81.41804,
                title: "Lane Stadium \(num)"
            )
            sut.addDestination(newDestination)
        }
        sut.addDestination(laneStadiumDestination)
        for num in 3..<5 {
            let newDestination = Destination(
                latitude: 38.22001,
                longitude: -81.41804,
                title: "Lane Stadium \(num)"
            )
            sut.addDestination(newDestination)
        }

        sut.deleteDestination(laneStadiumDestination)

        #expect(dataServiceSpy.destinationTitles == [
            "Lane Stadium 0",
            "Lane Stadium 1",
            "Lane Stadium 2",
            "Lane Stadium 3",
            "Lane Stadium 4"
        ])
        #expect(sut.destinations == dataServiceSpy.destinations)
    }

    @Test
    func refreshDestinations_shouldCallDataService() {
        sut.destinations = []
        dataServiceSpy.destinations = [laneStadiumDestination]

        sut.refreshDestinations()

        #expect(sut.destinations == dataServiceSpy.destinations)
    }

    @Test
    func addressFromLocation_shouldReturnAddressString() async {
        let laneStadiumLocation2D = CLLocationCoordinate2D(
            latitude: 37.22001,
            longitude: -80.41804
        )
        let laneStadiumAddressDictionary: [String: Any] = [
            "thoroughfare": "Beamer Way",
            "subThoroughfare": "185",
            "locality": "Blacksburg",
            "state": "VA",
            "address": "185 Beamer Way Blacksburg, VA",
            "postalCode": "24061",
            "country": "United States"
        ]
        let laneStadiumPlacemark = CLPlacemark(
            placemark: MKPlacemark(
                coordinate: laneStadiumLocation2D,
                addressDictionary: laneStadiumAddressDictionary
            )
        )
        geocoderSpy.expectedPlacemarks = [laneStadiumPlacemark]
        let laneStadiumLocation = CLLocation(
            latitude: 37.22001,
            longitude: -80.41804
        )

        let address = await sut.addressFromLocation(laneStadiumLocation)
        let expectedAddress = "185 Beamer Way Blacksburg, VA 24061 United States"

        #expect(expectedAddress.contains(address.trimmingCharacters(in: .whitespaces)))
    }

    @Test
    func addressFromLocation_withError_shouldThrowError() async {
        geocoderSpy.error = NSError(domain: "", code: 0, userInfo: nil)

        let address = await sut.addressFromLocation(CLLocation(latitude: 0, longitude: 0))

        #expect(geocoderSpy.errorCount == 1)
        #expect(address == "Unable to determine address")
    }

    @Test
    func reset_shouldClearSearchResultsAndSelectedLocationAndSearchCompletions() {
        sut.searchResults = Array(repeating: laneStadiumDestination, count: 4)
        sut.selectedDestination = laneStadiumDestination

        sut.reset()

        #expect(sut.searchResults.isEmpty)
        #expect(sut.selectedDestination == nil)
    }

    @Test
    func selectedDestinationUpdated_withValidDestination_shouldUpdateMapPositionAndSheets() {
        sut.isInfoSheetPresented = false
        sut.isSearchSheetPresented = true
        sut.selectedDestination = laneStadiumDestination

        #expect(sut.isInfoSheetPresented)
        #expect(!sut.isSearchSheetPresented)
        #expect(sut.position.item == laneStadiumItem)
    }

    @Test
    func selectedDestinationUpdated_withNilDestination_shouldCloseInfoSheet() {
        sut.isInfoSheetPresented = true
        sut.selectedDestination = nil

        #expect(!sut.isInfoSheetPresented)
    }

    @Test
    func selectedDestinationUpdated_withEmptyFeature_shouldCloseInfoSheet() {
        let destination = Destination(latitude: 0.0, longitude: 0.0)
        sut.selectedDestination = destination

        #expect(!sut.isInfoSheetPresented)
    }

    @Test
    func searchResultsUpdated_shouldUpdateSearchResultsArray() {
        sut.searchResultsUpdated([burrussHallDestination, laneStadiumDestination])

        let results = sut.searchResults.map { $0.title }
        #expect(results == ["", "Lane Stadium"])
    }

    @Test
    func searchResultsUpdated_withEmptyArray_shouldOnlyDismissSheet() {
        sut.isSearchSheetPresented = true
        let originalRegion = sut.position.region
        sut.searchResultsUpdated([])

        #expect(!sut.isSearchSheetPresented)
        #expect(sut.selectedDestination == nil)
        #expect(sut.position.region == originalRegion)
    }

    @Test
    func searchResultsUpdated_withSingleResult_shouldSetSelectedDestination() {
        sut.isSearchSheetPresented = true

        sut.searchResultsUpdated([laneStadiumDestination])

        #expect(!sut.isSearchSheetPresented)
        #expect(sut.selectedDestination == laneStadiumDestination)
        #expect(sut.position.item == laneStadiumItem)
    }

    @Test
    func searhResultsUpdated_withMultipleResults_shouldChangeMapPositionAndDeselectDestinations() {
        sut.isSearchSheetPresented = true
        sut.selectedDestination = laneStadiumDestination
        let burrussHallRegion = MKCoordinateRegion(
            center: burrussHallDestination.coordinate,
            latitudinalMeters: 10000,
            longitudinalMeters: 10000
        )
        sut.searchResultsUpdated([burrussHallDestination, laneStadiumDestination])

        #expect(!sut.isSearchSheetPresented)
        #expect(sut.selectedDestination == nil)
        #expect(sut.position.region == burrussHallRegion)
    }

    @Test
    func addPin_shouldAddPin() {
        sut.addPin(laneStadiumDestination)

        #expect(sut.tappedLocations == [laneStadiumDestination])
        #expect(sut.selectedDestination == laneStadiumDestination)
    }

    @Test
    func isPin_withPinnedDestination_shouldReturnTrue() {
        sut.tappedLocations = [laneStadiumDestination]

        #expect(sut.isPin(laneStadiumDestination))
    }

    @Test
    func isPin_withNotPinnedDestination_shouldReturnFalse() {
        sut.tappedLocations = []

        #expect(!sut.isPin(laneStadiumDestination))
    }

    @Test
    func removePin_shouldRemovePin() {
        sut.tappedLocations.append(laneStadiumDestination)
        sut.isInfoSheetPresented = true

        sut.removePin(laneStadiumDestination)

        #expect(sut.tappedLocations.isEmpty)
        #expect(!sut.isInfoSheetPresented)
    }

    @Test
    func selectDestinationFromList_shouldChangeTabSelectionAndSetSelectedDestination() {
        sut.selectDestinationFromList(laneStadiumDestination)

        #expect(!sut.isListSheetPresented)
        #expect(sut.selectedDestination == laneStadiumDestination)
    }

    @Test
    func startNavigation_shouldShowAlert() {
        sut.startNavigation()

        #expect(sut.isNavigationAlertPresented)
    }

    @Test
    func isSaved_withSavedDestination_shouldReturnTrue() {
        sut.destinations = [laneStadiumDestination]

        #expect(sut.isSaved(laneStadiumDestination))
    }

    @Test
    func isSaved_withUnSavedDestination_shouldReturnFalse() {
        #expect(!sut.isSaved(laneStadiumDestination))
    }
}

extension MKCoordinateRegion: @retroactive Equatable {
    public static func == (lhs: MKCoordinateRegion, rhs: MKCoordinateRegion) -> Bool {
        lhs.center == rhs.center && lhs.span == rhs.span
    }
}

extension CLLocationCoordinate2D: @retroactive Equatable {
    public static func == (lhs: CLLocationCoordinate2D, rhs: CLLocationCoordinate2D) -> Bool {
        lhs.latitude == rhs.latitude && lhs.longitude == rhs.longitude
    }
}

extension MKCoordinateSpan: @retroactive Equatable {
    public static func == (lhs: MKCoordinateSpan, rhs: MKCoordinateSpan) -> Bool {
        lhs.latitudeDelta == rhs.latitudeDelta && lhs.longitudeDelta == rhs.longitudeDelta
    }
}
