//
//  SearchViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/12/25.
//

import Testing
@testable import TwoWheels
import MapKit

@MainActor
struct SearchViewModelTests {
    let searchServiceSpy: SearchServiceSpy
    let laneStadiumDestination: Destination
    let burrussHallDestination: Destination

    init() {
        searchServiceSpy = SearchServiceSpy()
        laneStadiumDestination = Destination(
            latitude: 37.22001,
            longitude: -80.41804,
            title: "Lane Stadium"
        )
        burrussHallDestination = Destination(
            latitude: 37.229000,
            longitude: -80.423710,
            title: "Burruss Hall"
        )
    }

    @Test
    func init_shouldHaveNoSearchResults() {
        let sut = makeSUT()

        #expect(sut.searchResults.isEmpty)
    }

    @Test
    func search_withEmptySting_shouldReturnNoResults() async {
        let sut = makeSUT()

        await sut.search()

        #expect(sut.searchResults == [])
    }

    @Test
    func search_withNonEmptyString_shouldCallSearchService() async throws {
        let region = MKCoordinateRegion(
            center: CLLocationCoordinate2D(
                latitude: 37.22001,
                longitude: -80.41804
            ),
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        let sut = makeSUT(region: region)
        sut.searchString = "Lane Stadium"
        
        await sut.search()

        let request = try #require(searchServiceSpy.request)
        #expect(searchServiceSpy.callCount == 1)
        #expect(request.naturalLanguageQuery == "Lane Stadium")
        #expect(request.region == region)
    }

    @Test
    func search_withNonEmptyString_shouldUpdateSearchResults() async {
        let expectedSearchResults = [
            laneStadiumDestination,
            burrussHallDestination
        ]
        searchServiceSpy.expectedSearchResults = expectedSearchResults.map { result in
            let placemark = MKPlacemark(coordinate: result.coordinate)
            let item = MKMapItem(placemark: placemark)
            item.name = result.title
            return item
        }
        let sut = makeSUT()
        sut.searchString = "Lane Stadium"

        await sut.search()

        #expect(sut.searchResults[0].title == "Lane Stadium")
        #expect(sut.searchResults[1].title == "Burruss Hall")
    }

    // MARK: Helpers

    func makeSUT(region: MKCoordinateRegion = .init()) -> SearchViewModel {
        SearchViewModel(region: region, searchService: searchServiceSpy)
    }
}
