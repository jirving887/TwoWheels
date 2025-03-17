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
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
                if !viewModel.searchResults.isEmpty {
                    Button {
                        viewModel.reset()
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .frame(minWidth: 45, minHeight: 45)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(5)
                }
                
                Button {
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
            MapSheetView()
        }
        .sheet(isPresented: $viewModel.isInfoSheetPresented) {
            if let location = viewModel.selectedLocation {
                LocationInfoView(location: location)
            }
        }
        .onMapCameraChange(frequency: .onEnd) { newPos in
            viewModel.visibleRegion = newPos.region
        }
        .environment(viewModel)
    }
}

#Preview {
    SearchableMapView()
}
