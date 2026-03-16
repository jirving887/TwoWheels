//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 8/17/25.
//

import MapKit
import SwiftUI

struct ExploreView: View {
    @State private var viewModel = ExploreViewModel()
    @State private var searchText = ""

    var body: some View {
        NavigationStack {
            Map(position: $viewModel.mapPosition, selection: $viewModel.selectedLocation) {
                UserAnnotation()
            }
            .edgesIgnoringSafeArea(.all)
        }
        .searchable(text: $viewModel.searchText) {
            if let completions = viewModel.searchCompletions {
                ForEach(completions, id: \.self) { completion in
                    Button {
                        viewModel.search(with: completion)
                    } label: {
                        Text(completion.title)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .contentShape(Rectangle())
                    }
                    .buttonStyle(.plain)
                }
            }
        }
        .onSubmit(of: .search) {
            print("Submitted")
        }
        .sheet(isPresented: $viewModel.isShowingDetailSheet) {
            viewModel.didDismissDetailSheet()
        } content: {
            if let selection = viewModel.selectedLocation,
               let location = selection.value {
                LocationDetailSheet(mapItem: location)
            }

        }
    }
}

#Preview {
    ExploreView()
}
