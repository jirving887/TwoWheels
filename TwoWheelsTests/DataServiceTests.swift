//
//  DataServiceTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 4/28/25.
//

import SwiftData
import MapKit
import Testing
@testable import TwoWheels

@MainActor
final class DataServiceTests {
    var container: ModelContainer!
    var sut: DataService<Destination>!
    var laneStadiumDestination: Destination!
    
    init() throws {
        let config = ModelConfiguration(isStoredInMemoryOnly: true)
        container = try ModelContainer(for: Destination.self, configurations: config)
        sut = DataService(modelContext: container.mainContext)
        
        let laneStadium = CLLocationCoordinate2D(latitude: 37.22001, longitude: -80.41804)
        let laneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: laneStadium))
        laneStadiumDestination = Destination(laneStadiumItem)
        laneStadiumDestination.title = "Lane Stadium"
    }
    
    deinit {
        container = nil
        sut = nil
    }
    
    @Test
    func fetch_withEmptyContext_returnsEmptyArray() {
        #expect(sut.fetch() == [])
    }
    
    @Test
    func fetch_withNonEmptyContext_returnsNonEmptyArray() {
        container.mainContext.insert(laneStadiumDestination)
        
        let expectedDestinations = sut.fetch().map { $0.title }
        #expect(expectedDestinations == ["Lane Stadium"])
    }
    
    @Test
    func add_shouldAddDestination() {
        sut.add(laneStadiumDestination)
        
        let expectedDestinations = sut.fetch().map { $0.title }
        #expect(expectedDestinations == ["Lane Stadium"])
    }
    
    @Test
    func add_withDuplicate_shouldNotAddDestination() {
        sut.add(laneStadiumDestination)
        sut.add(laneStadiumDestination)
        
        #expect(sut.fetch().map { $0.title } == ["Lane Stadium"])
    }
    
    @Test
    func remove_withNonAddedDestination_shouldNotChangeData() {
        let notlaneStadium = CLLocationCoordinate2D(latitude: 38.22001, longitude: -81.41804)
        let notlaneStadiumItem = MKMapItem(placemark: MKPlacemark(coordinate: notlaneStadium))
        let notlaneStadiumDestination = Destination(notlaneStadiumItem)
        notlaneStadiumDestination.title = "Not Lane Stadium"
        container.mainContext.insert(laneStadiumDestination)
        
        sut.remove(notlaneStadiumDestination)
        
        #expect(sut.fetch().map { $0.title } == ["Lane Stadium"])
    }
    
    @Test
    func remove_withAddedDestination_shouldRemoveDestination() {
        container.mainContext.insert(laneStadiumDestination)
        
        sut.remove(laneStadiumDestination)
        
        #expect(sut.fetch() == [])
    }
}
