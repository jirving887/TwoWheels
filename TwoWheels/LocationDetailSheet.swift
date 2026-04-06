//
//  LocationDetailSheet.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import MapKit
import SwiftUI

struct LocationDetailSheet: View {
    let location: Location

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(location.name)
                .font(.title2)
                .fontWeight(.semibold)

            Button {
                print("Navigating")
            } label: {
                Label("Navigate", systemImage: "bicycle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.borderedProminent)
            .controlSize(.large)
        }
        .padding()
    }
}

#Preview {
    ExploreView(viewModel: MockExploreViewModel())
}
