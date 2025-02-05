//
//  MapSheetView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/24/24.
//

import SwiftUI
import MapKit

struct MapSheetView: View {
    
    @Binding var searchRegion: MKCoordinateRegion
    @Binding var searchResults: [Destination]
    
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
                            searchResults = (try? await mapService.search(with: search, region: searchRegion)) ?? []
                        }
                    }
            }
            .modifier(TextFieldGrayBackgroundColor())
            
            Spacer()
            
            if !mapService.completions.isEmpty {
                List {
                    ForEach($mapService.completions, id: \.self) { completion in
                        Button(action: { didTapOnCompletion(completion.wrappedValue) }) {
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
            
        }
        .onChange(of: search) {
            if search.count == 1 {
                mapService.update(region: searchRegion)
            }
            mapService.update(queryFragment: search)
        }
        .padding()
        .presentationDetents([.fraction(0.20), .medium, .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
    
    private func didTapOnCompletion(_ completion: MKLocalSearchCompletion) {
        Task {
            searchResults = (try? await mapService.search(for: completion, region: searchRegion)) ?? []
        }
    }
}

struct TextFieldGrayBackgroundColor: ViewModifier {
    func body(content: Content) -> some View {
        content
            .padding(12)
            .background(.gray.opacity(0.1))
            .cornerRadius(8)
            .foregroundColor(.primary)
    }
}
