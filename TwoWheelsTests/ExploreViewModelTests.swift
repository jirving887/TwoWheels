//
//  ExploreViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 4/28/25.
//

import MapKit
import Testing
@testable import TwoWheels
import _MapKit_SwiftUI

struct ExploreViewModelTests {
    let dataServiceSpy: DataServiceSpy
    let searchServiceSpy: SearchServiceSpy
    let geocoderSpy: GeocoderSpy
    let directionsServiceSpy: DirectionsServiceSpy
    let sut: ExploreViewModel
    let laneStadiumDestination: Destination
    let burrussHallDestination: Destination
    
    init() {
        dataServiceSpy = DataServiceSpy()
        searchServiceSpy = SearchServiceSpy()
        geocoderSpy = GeocoderSpy()
        directionsServiceSpy = DirectionsServiceSpy()
        sut = ExploreViewModel(
            dataService: dataServiceSpy,
            searchService: searchServiceSpy,
            geocoder: geocoderSpy,
            directionsService: directionsServiceSpy
        )
        laneStadiumDestination = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium")
        burrussHallDestination = Destination(latitude: 37.229000, longitude: -80.423710)
    }
    
    @Test
    func init_withNonEmptyDataService_shouldHaveData() {
        dataServiceSpy.destinations = [laneStadiumDestination]
        let freshSut = ExploreViewModel(
            dataService: dataServiceSpy,
            searchService: searchServiceSpy,
            geocoder: geocoderSpy,
            directionsService: directionsServiceSpy
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
    func search_withEmptyString_shouldReturnNoResults() async {
        await sut.search()
        
        #expect(sut.searchResults == [])
    }
    
    @Test
    func search_withNonEmptyString_shouldReturnRelevantResults() async {
        let destination1 = Destination(
            latitude: 37.22001,
            longitude: -80.41804,
            title: "Lane Stadium 1"
        )
        let destination2 = Destination(
            latitude: 37.22001,
            longitude: -80.41804,
            title: "Lane Stadium 2"
        )
        let expectedSearchResults = [destination1, destination2]
        searchServiceSpy.expectedSearchResults = expectedSearchResults.map {
            $0.mapItem ?? MKMapItem()
        }
        sut.searchString = "Lane Stadium"
        
        await sut.search()
        
        #expect(sut.searchResults[0].title == "Lane Stadium 1")
        #expect(sut.searchResults[1].title == "Lane Stadium 2")
    }
    
    @Test
    func search_withSearchCompletion_shouldReturnRelevantResults() async {
        let completion = MKLocalSearchCompletion()
        let destination1 = Destination(
            latitude: 37.22001,
            longitude: -80.41804,
            title: "Lane Stadium 1"
        )
        let destination2 = Destination(
            latitude: 37.22001,
            longitude: -80.41804,
            title: "Lane Stadium 2"
        )
        let expectedSearchResults = [destination1, destination2]
        searchServiceSpy.expectedSearchResults = expectedSearchResults.map {
            $0.mapItem ?? MKMapItem()
        }
        
        await sut.search(with: completion)
        
        #expect(sut.searchResults[0].title == "Lane Stadium 1")
        #expect(sut.searchResults[1].title == "Lane Stadium 2")
    }
    
    @Test
    func search_withError_shouldThrowError() async {
        searchServiceSpy.error = NSError(domain: "", code: 0, userInfo: nil)
        
        await sut.search(with: MKLocalSearchCompletion())
        
        #expect(searchServiceSpy.errorCount == 1)
        #expect(sut.searchResults.isEmpty)
    }
    
    @Test
    func searchStringUpdated_withEmptyString_shouldEmptySearchCompletions() {
        sut.searchString = "L"
        sut.searchString = ""
        
        #expect(sut.searchCompletions.isEmpty)
    }
    
    @Test
    func searchStringUpdated_withSingleCharacter_shouldUpdateCompleterRegion() {
        let laneStadiumRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.22001,
                longitude: -80.41804
            ),
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        sut.visibleRegion = laneStadiumRegion
        
        sut.searchString = "L"
        
        #expect(sut.completer.region == laneStadiumRegion)
    }
    
    @Test
    func searchStringUpdated_withMultipleCharacters_shouldUpdateCompleterQuery() {
        sut.searchString = "Lane Stadium"
        
        #expect(sut.completer.queryFragment == "Lane Stadium")
    }
    
    @Test
    func addressFromLocation_shouldReturnAddressString() async {
        let laneStadiumLocation2D = CLLocationCoordinate2D(
            latitude: 37.22001,
            longitude: -80.41804
        )
        let laneStadiumAddressDictionary: [String : Any] = [
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
        sut.searchCompletions = Array(repeating: MKLocalSearchCompletion(), count: 4)
        sut.searchString = "Lane Stadium"
        
        sut.reset()
        
        #expect(sut.searchResults.isEmpty)
        #expect(sut.selectedDestination == nil)
        #expect(sut.searchCompletions.isEmpty)
        #expect(sut.searchString.isEmpty)
    }
    
    @Test
    func selectedDestinationUpdated_withValidDestination_shouldUpdateMapPositionAndSheets() {
        sut.isInfoSheetPresented = false
        sut.isSearchSheetPresented = true
        sut.selectedDestination = laneStadiumDestination
        
        #expect(sut.isInfoSheetPresented)
        #expect(!sut.isSearchSheetPresented)
        #expect(sut.position.item == laneStadiumDestination.mapItem)
    }
    
    @Test
    func selectedDestinationUpdated_withInvalidDestinationMapItem_shouldUpdateMapPositionAndSheets() {
        sut.isInfoSheetPresented = false
        sut.isSearchSheetPresented = true
        laneStadiumDestination.mapItem = nil
        sut.selectedDestination = laneStadiumDestination
        let laneStadiumRegion = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.22001,
                longitude: -80.41804
            ),
            latitudinalMeters: 200,
            longitudinalMeters: 200
        )
        
        #expect(sut.isInfoSheetPresented)
        #expect(!sut.isSearchSheetPresented)
        #expect(sut.position.region == laneStadiumRegion)
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
    func searchResultsUpdated_withEmptyArray_shouldOnlyDismissSheet() {
        sut.isSearchSheetPresented = true
        let originalRegion = sut.position.region
        sut.searchResults = []
        
        #expect(!sut.isSearchSheetPresented)
        #expect(sut.selectedDestination == nil)
        #expect(sut.position.region == originalRegion)
    }
    
    @Test
    func searchResultsUpdated_withSingleResult_shouldSetSelectedDestination() {
        sut.isSearchSheetPresented = true
        
        sut.searchResults = [laneStadiumDestination]
        
        #expect(!sut.isSearchSheetPresented)
        #expect(sut.selectedDestination == laneStadiumDestination)
        #expect(sut.position.item == laneStadiumDestination.mapItem)
    }
    
    @Test
    func searhResultsUpdated_withMultipleResults_shouldChangeMapPosition() {
        sut.isSearchSheetPresented = true
        sut.searchResults = [burrussHallDestination, laneStadiumDestination]
        
        #expect(!sut.isSearchSheetPresented)
        #expect(sut.position.item == burrussHallDestination.mapItem)
    }
    
    @Test
    func addPin_shouldAddPin() {
        sut.addPin(laneStadiumDestination)
        
        #expect(sut.tappedLocations == [laneStadiumDestination])
        #expect(sut.selectedDestination == laneStadiumDestination)
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
    func showDirections_shouldGetAndDisplayDirections() async {
        sut.selectedDestination = laneStadiumDestination
        
        await sut.showDirections()
        
        #expect(sut.route != nil)
        #expect(!sut.isInfoSheetPresented)
        #expect(sut.isDirectionsSheetPresented)
    }
    
    @Test
    func showDirections_withError_shouldShowAlert() async {
        directionsServiceSpy.error = NSError(domain: "", code: 0, userInfo: nil)
        sut.selectedDestination = laneStadiumDestination
        
        await sut.showDirections()
         
        #expect(directionsServiceSpy.errorCount == 1)
        #expect(sut.isDirectionsAlertPresented)
        #expect(sut.isInfoSheetPresented)
        #expect(!sut.isDirectionsSheetPresented)
        
    }
    
    @Test
    func showDirections_withNoSelectedDestination_shouldShowAlert() async throws {
        sut.selectedDestination = nil
        
        await sut.showDirections()
        
        #expect(sut.isDirectionsAlertPresented)
        #expect(!sut.isDirectionsSheetPresented)
    }
    
    @Test
    func updateDistance_withMeters_shouldSetRouteDistance() {
        sut.updateDistance(with: 1610)
        
        #expect(sut.routeDistance == "1.00 mi")
    }
    
    @Test(arguments: [
        (seconds: 3600, expectedTime: "1h"),
        (seconds: 217800, expectedTime: "2d, 12h, 30m"),
        (seconds: 1800, expectedTime: "30m"),
        (seconds: 86400, expectedTime: "1d"),
    ])
    func updateTime_withSeconds_shouldSetRouteTimeAndEta(seconds: Double, expectedTime: String) {
        sut.updateTime(with: seconds)
        
        #expect(sut.routeTime == expectedTime)
        #expect(sut.eta != "")
    }
    
    @Test
    func startNavigation_shouldShowAlert() {
        sut.startNavigation()
        
        #expect(sut.isNavigationAlertPresented)
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
