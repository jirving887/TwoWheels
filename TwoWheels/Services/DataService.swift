//
//  DataService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
import SwiftData

@MainActor
protocol DataManipulating<T> {
    associatedtype T: PersistentModel
    func fetch() -> [T]
    func add(_ data: T)
    func remove(_ data: T)
}

class DataService<T: PersistentModel>: DataManipulating {
    private let modelContainer: ModelContainer

    init(modelContainer: ModelContainer) {
        self.modelContainer = modelContainer
    }

    func fetch() -> [T] {
        do {
            let descriptor = FetchDescriptor<T>()
            return try modelContainer.mainContext.fetch(descriptor)
        } catch {
            print("Failed to fetch data with error: \n\(error)")
            return []
        }
    }

    func add(_ data: T) {
        modelContainer.mainContext.insert(data)
    }

    func remove(_ data: T) {
        modelContainer.mainContext.delete(data)
    }
}
