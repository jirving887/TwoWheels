//
//  Destinations.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/6/24.
//

import Foundation

class Destinations: ObservableObject {
    let places: [Destination]
    
    var primary: Destination {
        places[0]
    }
    
    init() {
        places = []
    }
    
}
