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
            center: laneStadiumDestination.coordinate,
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
        let sut = makeSUT()
        sut.searchString = "Lane Stadium"

        await sut.search()

        #expect(sut.searchResults[0].title == "Lane Stadium")
        #expect(sut.searchResults[1].title == "Burruss Hall")
    }

    @Test
    func search_withSearchCompletion_shouldCallSearchService() async throws {
        let completion = MKLocalSearchCompletion()
        let sut = makeSUT()

        await sut.search(with: completion)

        #expect(searchServiceSpy.callCount == 1)
    }

    @Test
    func search_withSearchCompletion_shouldUpdateSearchResults() async {
        let completion = MKLocalSearchCompletion()
        let sut = makeSUT()

        await sut.search(with: completion)

        #expect(sut.searchResults[0].title == "Lane Stadium")
        #expect(sut.searchResults[1].title == "Burruss Hall")
    }

    @Test
    func search_withError_shouldThrowError() async {
        searchServiceSpy.error = NSError(domain: "", code: 0, userInfo: nil)
        let sut = makeSUT()

        await sut.search(with: MKLocalSearchCompletion())

        #expect(searchServiceSpy.errorCount == 1)
        #expect(sut.searchResults.isEmpty)
    }

    @Test
    func searchStringUpdated_withEmptyString_shouldEmptySearchCompletions() {
        let sut = makeSUT()
        sut.searchString = "L"
        sut.searchString = ""

        #expect(sut.searchCompletions.isEmpty)
    }

    @Test
    func searchStringUpdated_withSingleCharacter_shouldUpdateCompleterRegion() {
        let region = MKCoordinateRegion(
            center: laneStadiumDestination.coordinate,
            latitudinalMeters: 1000,
            longitudinalMeters: 1000
        )
        let sut = makeSUT(region: region)

        sut.searchString = "L"

        #expect(sut.completer.region == region)
    }

    @Test
    func searchStringUpdated_withMultipleCharacters_shouldUpdateCompleterQuery() {
        let sut = makeSUT()
        sut.searchString = "Lane Stadium"

        #expect(sut.completer.queryFragment == "Lane Stadium")
    }

    // MARK: Helpers

    func makeSUT(region: MKCoordinateRegion = .init()) -> SearchViewModel {
        SearchViewModel(region: region, searchService: searchServiceSpy)
    }
}
