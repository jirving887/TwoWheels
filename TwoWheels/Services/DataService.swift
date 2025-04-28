//
//  DataService.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation

protocol DataService {
    func fetch() -> [Destination]
    func add(_ data: Destination)
    func remove(_ data: Destination)
}
