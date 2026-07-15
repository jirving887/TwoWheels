//
//  SearchUseCase.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 7/15/26.
//

import Foundation

protocol SearchUseCase {
    func search(for query: SearchQuery) async throws -> [Location]
}
