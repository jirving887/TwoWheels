//
//  Destination.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/6/24.
//

import Foundation

struct Destination: Identifiable {
    let id: UUID
    let name: String
    let address: String
    let city: String
    let state: String
    let zip: String
    let photos: [String]
    let type: DestinationType
}
