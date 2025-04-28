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
        []
    }
    
    func add(_ data: Destination) {}
    
    func remove(_ data: Destination) {}
    
    func update(_ data: Destination) {}
    
    
}
