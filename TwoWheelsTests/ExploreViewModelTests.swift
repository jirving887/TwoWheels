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
    let dataService: MockDataService
    let sut: ExploreViewModel
    let laneStadiumDestination: Destination
    
    init() {
        dataService = MockDataService()
        sut = ExploreViewModel(dataService: dataService)
        let laneStadium = CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        laneStadiumDestination = Destination(laneStadiumItem)
        laneStadiumDestination.title = "Lane Stadium"
    }
    
    @Test
    func test_addDestination_shouldAddDestination() {
        sut.addDestination(laneStadiumDestination)
        
        #expect(dataService.destinationTitles == ["Lane Stadium"])
        #expect(sut.destinations == dataService.destinations)
    }
    
    @Test
    func test_deleteDestination_shouldDeleteDestination() {
        for num in 0..<3 {
            let newLocation = CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804)
            let newItem = MKMapItem(placemark: MKPlacemark(coordinate: newLocation))
            let newDestination = Destination(newItem)
            newDestination.title = "Lane Stadium \(num)"
            sut.addDestination(newDestination)
        }
        sut.addDestination(laneStadiumDestination)
        for num in 3..<5 {
            let newLocation = CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804)
            let newItem = MKMapItem(placemark: MKPlacemark(coordinate: newLocation))
            let newDestination = Destination(newItem)
            newDestination.title = "Lane Stadium \(num)"
            sut.addDestination(newDestination)
        }
        
        sut.deleteDestination(laneStadiumDestination)
        
        #expect(dataService.destinationTitles == [
            "Lane Stadium 0",
            "Lane Stadium 1",
            "Lane Stadium 2",
            "Lane Stadium 3",
            "Lane Stadium 4"
        ])
        #expect(sut.destinations == dataService.destinations)
    }
}
