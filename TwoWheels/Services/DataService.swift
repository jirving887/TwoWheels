//
//  DataService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
import SwiftData

protocol DataManipulating<T>: Sendable {
    associatedtype T : PersistentModel
    func fetch() -> [T]
    func add(_ data: T)
    func remove(_ data: T)
}

class DataService<T : PersistentModel>: DataManipulating, @unchecked Sendable {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetch() -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch data with error: \n\(error)")
            return []
        }
    }
    
    func add(_ data: T) {
        modelContext.insert(data)
    }
    
    func remove(_ data: T) {
        modelContext.delete(data)
    }
}
