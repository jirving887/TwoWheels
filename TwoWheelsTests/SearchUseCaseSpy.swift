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

    func search(for query: SearchQuery) async throws -> [Location] {
        searchedQueries.append(query)
        return results
    }
}
