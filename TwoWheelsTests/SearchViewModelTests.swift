//
//  SearchViewModelTests.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/12/25.
//

import Testing
@testable import TwoWheels

@MainActor
struct SearchViewModelTests {

    @Test
    func init_shouldHaveNoSearchResults() {
        let sut = SearchViewModel()

        #expect(sut.searchResults.isEmpty)
    }

    @Test
    func search_withEmptySting_shouldReturnNoResults() async {
        let sut = SearchViewModel()

        await sut.search()
        
        #expect(sut.searchResults == [])
    }
}
