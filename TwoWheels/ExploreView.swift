//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import MapKit
import SwiftUI

struct ExploreView: View {
    var body: some View {
        NavigationStack {
            Map()
                .edgesIgnoringSafeArea(.all)
                .navigationBarHidden(true)
        }
    }
}

#Preview {
    ExploreView()
}
