//
//  CLLocationUpdatesFake.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 6/30/25.
//

import CoreLocation
import Foundation
@testable import TwoWheels

struct CLLocationUpdatesFake: AsyncSequence, AsyncIteratorProtocol {
    var current = CLLocationUpdateFake()

    mutating func next() async -> CLLocationUpdateFake? {
        return current
    }

    func makeAsyncIterator() -> CLLocationUpdatesFake {
        self
    }
}

struct CLLocationUpdateFake: Locatable {
    var location: CLLocation?
}
