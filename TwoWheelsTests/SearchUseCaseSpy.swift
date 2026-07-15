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

    func search(for query: SearchQuery) async throws -> [Location] {
        searchedQueries.append(query)
        return []
    }
}
