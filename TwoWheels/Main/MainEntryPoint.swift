//
//  MainEntryPoint.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 11/25/24.
//

import SwiftUI

@main
struct MainEntryPoint {
    
    static func main() {
        guard isProduction() else {
            TwoWheelsTestApp.main()
            return
        }
        
        TwoWheelsApp.main()
    }
    
    private static func isProduction() -> Bool {
        NSClassFromString("XCTestCase") == nil
    }
}
