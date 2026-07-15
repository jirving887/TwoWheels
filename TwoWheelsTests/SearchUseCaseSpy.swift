//
//  SearchUseCaseSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 7/15/26.
//

import Foundation
@testable import TwoWheels

final class SearchUseCaseSpy: SearchUseCase {
    var searchedQueries = [SearchQuery]()
    var results = [Location]()
    var shouldThrowError = false

    func search(for query: SearchQuery) async throws -> [Location] {
        if shouldThrowError {
            throw NSError(domain: "SearchUseCaseSpy", code: 0)
        }
        searchedQueries.append(query)
        return results
    }
}
