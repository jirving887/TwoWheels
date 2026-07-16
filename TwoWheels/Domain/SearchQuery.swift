//
//  SearchQuery.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 7/15/26.
//

import Foundation

struct SearchQuery: Equatable {
    let queryString: String
    let latitude: Double
    let longitude: Double
    let latitudeDelta: Double
    let longitudeDelta: Double
}
