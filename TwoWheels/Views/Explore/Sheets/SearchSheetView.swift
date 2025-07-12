//
//  SearchSheetView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/24/24.
//

import MapKit
import SwiftUI

struct SearchSheetView: View {
    @State private var viewModel: SearchViewModel

    init(region: MKCoordinateRegion, onSearchComplete: @escaping ([Destination]) -> Void) {
        let searchService = SearchService { MKLocalSearch(request: $0) }
        _viewModel = State(initialValue: SearchViewModel(
            region: region,
            searchService: searchService,
            onSearchComplete: onSearchComplete
        ))
    }

    var body: some View {
        @Bindable var viewModel = viewModel
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search for a new destination", text: $viewModel.searchString)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            await viewModel.search()
                        }
                    }
            }
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
            
            Spacer()
            
            List {
                ForEach($viewModel.searchCompletions, id: \.self) { completion in
                    Button {
                        Task {
                            await viewModel.search(with: completion.wrappedValue)
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
        .padding()
        .presentationDetents([.fraction(0.20), .medium, .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
}

#Preview {
    let region = MKCoordinateRegion(
        center: CLLocationCoordinate2D(
            latitude: 37.22001,
            longitude: -80.41804
        ),
        latitudinalMeters: 1000,
        longitudinalMeters: 1000
    )

    return SearchSheetView(region: region) { _ in }
}
