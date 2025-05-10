//
//  ExploreViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 4/28/25.
//

import MapKit
import Testing
@testable import TwoWheels

struct ExploreViewModelTests {
    let dataServiceSpy: DataServiceSpy
    let searchServiceSpy: SearchServiceSpy
    let sut: ExploreViewModel
    let laneStadiumDestination: Destination
    
    init() {
        dataServiceSpy = DataServiceSpy()
        searchServiceSpy = SearchServiceSpy()
        sut = ExploreViewModel(dataService: dataServiceSpy, searchService: searchServiceSpy)
        laneStadiumDestination = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium")
    }
    
    @Test
    func init_withNonEmptyDataService_shouldHaveData() {
        dataServiceSpy.destinations = [laneStadiumDestination]
        let freshSut = ExploreViewModel(dataService: dataServiceSpy, searchService: searchServiceSpy)
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
            let newDestination = Destination(latitude: 38.22001, longitude: -81.41804, title: "Lane Stadium \(num)")
            sut.addDestination(newDestination)
        }
        sut.addDestination(laneStadiumDestination)
        for num in 3..<5 {
            let newDestination = Destination(latitude: 38.22001, longitude: -81.41804, title: "Lane Stadium \(num)")
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
        let destination1 = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium 1")
        let destination2 = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium 2")
        let expectedSearchResults = [destination1, destination2]
        searchServiceSpy.expectedSearchResults = expectedSearchResults.map { $0.mapItem ?? MKMapItem() }
        sut.searchString = "Lane Stadium"
        
        await sut.search()
        
        #expect(sut.searchResults[0].title == "Lane Stadium 1")
        #expect(sut.searchResults[1].title == "Lane Stadium 2")
    }
    
    @Test
    func search_withSearchCompletion_shouldReturnRelevantResults() async {
        let completion = MKLocalSearchCompletion()
        let destination1 = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium 1")
        let destination2 = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium 2")
        let expectedSearchResults = [destination1, destination2]
        searchServiceSpy.expectedSearchResults = expectedSearchResults.map { $0.mapItem ?? MKMapItem() }
        
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
        let laneStadiumRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804), latitudinalMeters: 1000, longitudinalMeters: 1000)
        sut.visibleRegion = laneStadiumRegion
        
        sut.searchString = "L"
        
        #expect(sut.completer.region == laneStadiumRegion)
    }
    
    @Test
    func searchStringUpdated_withMultipleCharacters_shouldUpdateCompleterQuery() {
        sut.searchString = "Lane Stadium"
        
        #expect(sut.completer.queryFragment == "Lane Stadium")
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
