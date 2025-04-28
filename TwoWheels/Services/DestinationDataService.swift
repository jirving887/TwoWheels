//
//  DestinationDataService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
import SwiftData

class DestinationDataService: DataService {
    private let modelContext: ModelContext
    
    init(modelContext: ModelContext) {
        self.modelContext = modelContext
    }
    
    func fetch() -> [Destination] {
        do {
            let descriptor = FetchDescriptor<Destination>(sortBy: [SortDescriptor(\.title)])
            return try modelContext.fetch(descriptor)
        } catch {
            print("Failed to fetch destinations with error: \n\(error)")
            return []
        }
    }
    
    func add(_ data: Destination) {
        modelContext.insert(data)
    }
    
    func remove(_ data: Destination) {
        modelContext.delete(data)
    }
    
    func update(_ data: Destination) {}
    
    
}
