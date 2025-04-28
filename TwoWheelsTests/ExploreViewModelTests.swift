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
    
    @Test
    func test_addDestination_shouldAddDestination() {
        let dataService = MockDataService()
        let sut = ExploreViewModel(dataService: dataService)
        let laneStadium = CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        let laneStadiumDestination = Destination(laneStadiumItem)
        laneStadiumDestination.title = "Lane Stadium"
        
        sut.addDestination(laneStadiumDestination)
        
        #expect(dataService.destinationTitles == ["Lane Stadium"])
        #expect(sut.destinations == dataService.destinations)
    }
}
