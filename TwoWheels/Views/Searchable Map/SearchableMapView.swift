//
//  SearchableMapView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/24/24.
//

import MapKit
import SwiftData
import SwiftUI

struct SearchableMapView: View {
    
    let manager = CLLocationManager()
    
    @Query(sort: \Destination.title) var destinations: [Destination]
    
    @State private var viewModel = SearchableMapViewModel()
    
    var body: some View {
        
        Map(position: $viewModel.position, selection: $viewModel.selectedLocation) {
            
            ForEach(destinations) { destination in
                Marker(coordinate: destination.coordinate) {
                        Label(destination.title, systemImage: "star")
                    }
                    .tint(.yellow)
            }
            
            ForEach(viewModel.searchResults) { result in
                if let item = result.mapItem {
                    Marker(coordinate: item.placemark.coordinate) {
                            Image(systemName: "mappin")
                        }
                        .tag(result)
                }
            }
            UserAnnotation()
        }
        .mapControls {
            MapScaleView()
            MapUserLocationButton()
            MapCompass()
            MapPitchToggle()
        }
        .onAppear {
            manager.requestWhenInUseAuthorization()
        }
        .mapControlVisibility(.visible)
        .onChange(of: viewModel.searchResults) {
            // TODO: Move to ViewModel
            if let firstResult = viewModel.searchResults.first, viewModel.searchResults.count == 1 {
                viewModel.selectedLocation = firstResult
            }
            if !viewModel.searchResults.isEmpty {
                viewModel.position = .automatic
                viewModel.isSearchSheetPresented = false
            }
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
                if !viewModel.searchResults.isEmpty {
                    Button {
                        // TODO: Move to ViewModel
                        viewModel.searchResults = []
                        viewModel.selectedLocation = nil
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .frame(minWidth: 45, minHeight: 45)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(5)
                }
                
                Button {
                    // TODO: Move to ViewModel?
                    viewModel.isSearchSheetPresented.toggle()
                } label: {
                    Image(systemName: "magnifyingglass")
                }
                .frame(minWidth: 45, minHeight: 45)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(5)
            }
            .padding(.trailing, 5)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $viewModel.isSearchSheetPresented) {
            MapSheetView(searchRegion: $viewModel.visibleRegion, searchResults: $viewModel.searchResults)
        }
        .sheet(
            isPresented: $viewModel.isInfoSheetPresented,
            onDismiss: {
                // TODO: Move to ViewModel?
                viewModel.selectedLocation = nil
            }) {
                if let selectedLocation = viewModel.selectedLocation {
                    LocationInfoView(location: selectedLocation)
                }
        }
        .onMapCameraChange(frequency: .onEnd) { newPos in
            // TODO: Move to ViewModel?
            viewModel.visibleRegion = newPos.region
        }
    }
}

#Preview {
    SearchableMapView()
}
