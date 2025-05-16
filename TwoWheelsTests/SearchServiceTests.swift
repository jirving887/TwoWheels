//
//  SearchServiceTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 5/15/25.
//

import MapKit
import Testing
@testable import TwoWheels

struct SearchServiceTests {

    @Test
    func search_shouldCallStartOnce() async throws {
        let sut = TestableSearchService()
        
        _ = try await sut.search(with: .init())
        
        #expect(sut.localSearch.startCount == 1)
    }

}

class TestableSearchService: SearchService {
    var localSearch: MKLocalSearchSpy!
    
    override func makeLocalSearch(_ request: MKLocalSearch.Request) -> MKLocalSearchSpy {
        localSearch = MKLocalSearchSpy(request: request)
        return localSearch
    }
}

class MKLocalSearchSpy: MKLocalSearch {
    var startCount = 0
    
    override func start() async throws -> MKLocalSearch.Response {
        startCount += 1
        return .init()
    }
}
