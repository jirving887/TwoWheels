//
//  SwiftDataService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation
import SwiftData

protocol SwiftDataCrudService<T> {
    associatedtype T : PersistentModel
    func fetch() -> [T]
    func add(_ data: T)
    func remove(_ data: T)
}
