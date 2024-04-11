//
//  SearchableMapView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/24/24.
//

import MapKit
import SwiftUI

struct SearchableMapView: View {
    
    @State private var position = MapCameraPosition.automatic
    @State private var searchResults = [SearchResult]()
    @State private var selectedLocation: SearchResult?
    @State private var isSheetPresented: Bool = false
    @State private var scene: MKLookAroundScene?
    @State private var searchText: String = ""
    
    var body: some View {
//        ZStack {
            
            Map(position: $position, selection: $selectedLocation) {
                ForEach(searchResults) { result in
                    Marker(coordinate: result.location) {
                        Image(systemName: "mappin")
                    }
                    .tag(result)
                }
                UserAnnotation()
            }
            .mapControls {
                MapScaleView()
                MapUserLocationButton()
                MapCompass()
                MapPitchToggle()
            }
            .mapControlVisibility(.visible)
            .onChange(of: selectedLocation) {
                if let selectedLocation {
                    Task {
                        scene = try? await fetchScene(for: selectedLocation.location)
                    }
                }
                isSheetPresented = selectedLocation == nil
            }
            .onChange(of: searchResults) {
                if let firstResult = searchResults.first, searchResults.count == 1 {
                    selectedLocation = firstResult
                }
            }
            
            .searchable(text: $searchText)
            .overlay(alignment: .bottomTrailing) {
                Button {
                    isSheetPresented.toggle()
                } label: {
                        Image(systemName: "magnifyingglass")
                }
                .sheet(isPresented: $isSheetPresented, content: {
                    MapSheetView(searchResults: $searchResults)
    //                    .presentationDetents([.fraction(0.20), .medium, .large])
                })
                .frame(minWidth: 50, minHeight: 50)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(5)
                .padding(.trailing, 20)
                .padding(.bottom, 20)
//                .background(Color(UIColor.systemBackground))
//                .buttonStyle(.bordered)
                
                
            }
            
//            VStack {
//                Button {
//                    isSheetPresented.toggle()
//                } label: {
//                    Image(systemName: "magnifyingglass")
//                }
//                .frame(alignment: .leading)
//                
//                Spacer()
//            }
//        }
        
        
        
    }
    
    private func fetchScene(for coordinate: CLLocationCoordinate2D) async throws -> MKLookAroundScene? {
        let lookAroundScene = MKLookAroundSceneRequest(coordinate: coordinate)
        return try await lookAroundScene.scene
    }
}

#Preview {
    SearchableMapView()
}
