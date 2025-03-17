//
//  TwoWheels.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 11/25/24.
//

import SwiftUI

@main
struct TwoWheels {
    
    static func main() {
        guard isProduction() else {
            TwoWheelsTests.main()
            return
        }
        
        TwoWheelsApp.main()
    }
    
    private static func isProduction() -> Bool {
        NSClassFromString("XCTestCase") == nil
    }
}
