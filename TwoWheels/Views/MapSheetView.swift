//
//  MapSheetView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/24/24.
//  Reference: https://www.polpiella.dev/mapkit-and-swiftui-searchable-map/
//

import SwiftUI
import MapKit

struct MapSheetView: View {
    
    let searchRegion: MKCoordinateRegion?
    
    @State private var locationService = LocationService(completer: .init())
    @State private var search: String = ""
    
    @Binding var searchResults: [SearchResult]
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: "magnifyingglass")
                
                TextField("Search for a new destination", text: $search)
                    .autocorrectionDisabled()
                    .onSubmit {
                        Task {
                            searchResults = (try? await locationService.search(with: search, region: searchRegion)) ?? []
                        }
                    }
            }
            .modifier(TextFieldGrayBackgroundColor())
            
            Spacer()
            
            List {
                ForEach(locationService.completions) { completion in
                    Button(action: { didTapOnCompletion(completion) }) {
                        VStack(alignment: .leading, spacing: 4) {
                            Text(completion.title)
                                .font(.headline)
                                .fontDesign(.rounded)
                            
                            Text(completion.subTitle)
                            
                            if let url = completion.url {
                                Link(url.absoluteString, destination: url)
                                    .lineLimit(1)
                            }
                        }
                    }
                    .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
        }
        .onChange(of: search) {
            if (searchRegion != nil && search.count < 1) {
                locationService.updateCompleterRegion(searchRegion!)
            }
            locationService.update(queryFragment: search)
        }
        .padding()
        .presentationDetents([.fraction(0.20), .medium, .large])
//        .interactiveDismissDisabled()
//        .presentationDetents([.height(200), .large])
        .presentationBackground(.regularMaterial)
        .presentationBackgroundInteraction(.enabled(upThrough: .large))
    }
    
    private func didTapOnCompletion(_ completion: SearchCompletions) {
        Task {
            if let singleLocation = try? await locationService.search(with: "\(completion.title) \(completion.subTitle)", region: searchRegion).first {
                searchResults = [singleLocation]
            }
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

//#Preview {
//    MapSheetView()
//}
