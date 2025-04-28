//
//  MockDataService.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
@testable import TwoWheels

class MockDataService: DataService {
    var destinations: [Destination] = []
    var destinationTitles: [String] {
        destinations.map { $0.title }
    }
    
    func fetch() -> [Destination] {
        destinations
    }
    
    func add(_ data: Destination) {
        destinations.append(data)
    }
    
    func remove(_ data: Destination) {
        destinations.removeAll { $0.id == data.id }
    }
    
    func update(_ data: Destination) {
        print("Updating \(data.title)")
    }
    
    
}
