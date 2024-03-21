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
        places = [Destination(id: UUID(), name: "Home", address: "10104 Pond Ct", city: "Gordonsville", state: "VA", zip: "22942", photos: [""], type: .residence), Destination(id: UUID(), name: "Autism Ranch", address: "9266 Epps Rd", city: "Mechanicsville", state: "VA", zip: "23111", photos: [""], type: .residence)]
    }
    
}
