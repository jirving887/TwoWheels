//
//  MapSheetView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/24/24.
//

import MapKit
import SwiftUI

struct MapSheetView: View {
    @Environment(SearchableMapViewModel.self) var viewModel
    
    @State private var mapService = MapService(completer: .init())
    @State private var search: String = ""
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search for a new destination", text: $search)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            viewModel.searchResults = (try? await mapService.search(for: search, in: viewModel.visibleRegion)) ?? []
                        }
                    }
            }
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
            
            Spacer()
            
            List {
                ForEach($mapService.completions, id: \.self) { completion in
                    Button {
                        Task {
                            viewModel.searchResults = (try? await mapService.search(for: completion.wrappedValue, in: viewModel.visibleRegion)) ?? []
                        }
                    } label: {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(completion.wrappedValue.title)
                                .font(.headline)
                                .fontDesign(.rounded)
                            
                            Text(completion.wrappedValue.subtitle)
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .onChange(of: search) {
            if search.count == 1 {
                mapService.update(region: viewModel.visibleRegion)
            }
            mapService.update(queryFragment: search)
        }
        .padding()
        .presentationDetents([.fraction(0.20), .medium, .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
}
