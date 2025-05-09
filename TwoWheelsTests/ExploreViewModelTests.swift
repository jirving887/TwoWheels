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
    let mapServiceSpy: MapServiceSpy
    let sut: ExploreViewModel
    let laneStadiumDestination: Destination
    
    init() {
        dataServiceSpy = DataServiceSpy()
        mapServiceSpy = MapServiceSpy()
        sut = ExploreViewModel(dataService: dataServiceSpy, mapService: mapServiceSpy)
        laneStadiumDestination = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium")
    }
    
    @Test
    func init_withNonEmptyDataService_shouldHaveData() {
        dataServiceSpy.destinations = [laneStadiumDestination]
        let freshSut = ExploreViewModel(dataService: dataServiceSpy, mapService: mapServiceSpy)
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
    func search_withEmptyString_shouldReturnNoResults() {
        sut.search()
        
        #expect(sut.searchResults == [])
    }
    
    @Test
    func search_withNonEmptyString_shouldReturnRelevantResults() {
        let destination1 = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium 1")
        let destination2 = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium 2")
        let expectedSearchResults = [destination1, destination2]
        mapServiceSpy.expectedSearchResults = expectedSearchResults.map { $0.mapItem ?? MKMapItem() }
        sut.searchString = "Lane Stadium"
        
        sut.search()
        
        #expect(sut.searchResults[0].title == "Lane Stadium 1")
        #expect(sut.searchResults[1].title == "Lane Stadium 2")
    }
    
    @Test
    func search_withSearchCompletion_shouldReturnRelevantResults() {
        let completion = MKLocalSearchCompletion()
        let destination1 = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium 1")
        let destination2 = Destination(latitude: 37.22001, longitude: -80.41804, title: "Lane Stadium 2")
        let expectedSearchResults = [destination1, destination2]
        mapServiceSpy.expectedSearchResults = expectedSearchResults.map { $0.mapItem ?? MKMapItem() }
        
        sut.search(with: completion)
        
        #expect(sut.searchResults[0].title == "Lane Stadium 1")
        #expect(sut.searchResults[1].title == "Lane Stadium 2")
    }
    
    @Test
    func searchStringUpdated_withOneCharacterString_shouldUpdateSearchRegion() {
        let region = MKCoordinateRegion(center: laneStadiumDestination.coordinate, latitudinalMeters: 1000, longitudinalMeters: 1000)
        sut.visibleRegion = region
        
        sut.searchString = "L"
        
        #expect(mapServiceSpy.searchRegion == region)
    }
}
