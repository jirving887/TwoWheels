//
//  DirectionsOverviewViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 7/16/25.
//

import Foundation

@MainActor
@Observable
class DirectionsOverviewViewModel {
    func calculateDistance(with meters: Double) -> String {
        let miles = meters / 1609.34
        return String(format: "%.2f mi", miles)
    }
}
