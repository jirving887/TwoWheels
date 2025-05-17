//
//  DirectionsOverviewView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 5/17/25.
//

import MapKit
import SwiftUI

struct DirectionsOverviewView: View {
    var body: some View {
        VStack {
            Map()
                .cornerRadius(20)
            
            HStack {
                GroupBox {
                    Text("Distance")
                }
                
                GroupBox {
                    Text("Travel Time")
                }
                
                GroupBox {
                    Text("ETA")
                }
            }
            
            Button {
            } label: {
                Text("Go")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .tint(.green)
            .frame(maxWidth: .infinity)
        }
        .padding()
    }
}

#Preview {
    DirectionsOverviewView()
}
