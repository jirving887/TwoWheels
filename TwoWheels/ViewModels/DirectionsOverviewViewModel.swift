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

    func calculateTime(with seconds: Double) -> String {
        let time = Int(seconds)
        let days: Int = time / 86400
        let hours: Int = (time % 86400) / 3600
        let minutes: Int = ((time % 86400) % 3600) / 60
        var result: [String] = []
        if days > 0 { result.append("\(days)d") }
        if hours > 0 { result.append("\(hours)h") }
        if minutes > 0 { result.append("\(minutes)m") }
        return result.joined(separator: ", ")
    }
}
