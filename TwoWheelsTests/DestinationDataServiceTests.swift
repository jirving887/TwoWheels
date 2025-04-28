//
//  DestinationDataServiceTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 4/28/25.
//

import SwiftData
import MapKit
import Testing
@testable import TwoWheels

@MainActor
final class DestinationDataServiceTests {
    @Test
    func fetch_withEmptyContext_returnsEmptyArray() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)
        
        let sut = DestinationDataService(modelContext: container.mainContext)
        
        #expect(sut.fetch() == [])
    }
    
    @Test
    func fetch_withNonEmptyContext_returnsNonEmptyArray() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        let container = try ModelContainer(for: Destination.self, configurations: config)
        
        let laneStadium = CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        let laneStadiumDestination = Destination(laneStadiumItem)
        laneStadiumDestination.title = "Lane Stadium"
        
        let sut = DestinationDataService(modelContext: container.mainContext)
        container.mainContext.insert(laneStadiumDestination)
        
        #expect(sut.fetch().count == 1)
    }

}
