//
//  CLLocationManagerSpy.swift
//  TwoWheelsTests
//
//  Created by Jonathan Irving on 8/17/25.
//

import CoreLocation
import Foundation
@testable import TwoWheels

final class CLLocationManagerSpy: Locating {
    var requestCallCount = 0

    func requestWhenInUseAuthorization() {
        requestCallCount += 1
    }
}
