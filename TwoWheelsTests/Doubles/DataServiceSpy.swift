//
//  DataServiceSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
@testable import TwoWheels

class DataServiceSpy: DataManupilating {
    var destinations: [Destination] = []
    var destinationTitles: [String] {
        destinations.map { $0.title }
    }
    
    /// Returns the current list of stored `Destination` objects.
    func fetch() -> [Destination] {
        destinations
    }
    
    /// Appends a `Destination` object to the internal destinations array.
    ///
    /// - Parameter data: The `Destination` to add.
    func add(_ data: Destination) {
        destinations.append(data)
    }
    
    /// Removes all destinations from the collection that have the same identifier as the given destination.
    ///
    /// - Parameter data: The destination whose identifier is used to find and remove matching entries.
    func remove(_ data: Destination) {
        destinations.removeAll { $0.id == data.id }
    }
}
