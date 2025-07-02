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
        var localSearchSpy = MKLocalSearchSpy(request: .init())
        let sut = await SearchService {
            localSearchSpy = MKLocalSearchSpy(request: $0)
            return localSearchSpy
        }
        
        _ = try await sut.search(with: .init())
        
        #expect(localSearchSpy.startCount == 1)
    }
}
