//
//  DataService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
import SwiftData

protocol DataManupilating<T> {
    associatedtype T : PersistentModel
    func fetch() -> [T]
    func add(_ data: T)
    func remove(_ data: T)
}

class DataService<T : PersistentModel>: DataManupilating {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    /// Retrieves all persistent objects of type `T` from the model context.
    ///
    /// - Returns: An array of objects of type `T`. Returns an empty array if fetching fails.
    func fetch() -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch destinations with error: \n\(error)")
            return []
        }
    }
    
    /// Inserts the specified persistent model object into the data context.
    ///
    /// - Parameter data: The object to be added to persistent storage.
    func add(_ data: T) {
        modelContext.insert(data)
    }
    
    /// Removes the specified persistent model from the data context.
    ///
    /// - Parameter data: The model instance to be deleted from persistence.
    func remove(_ data: T) {
        modelContext.delete(data)
    }
}
