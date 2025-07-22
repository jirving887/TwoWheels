//
//  TwoWheelsViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 7/21/25.
//

import Foundation
import MapKit

@Observable
class TwoWheelsViewModel {
    var route: MKRoute?

    func navigate(route: MKRoute) {
        self.route = route
    }

    func endNavigation() {
        route = nil
    }
}
