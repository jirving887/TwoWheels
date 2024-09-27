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
    
    @Query(sort: \Destination.name) var destinations: [Destination]
    
    @State private var position = MapCameraPosition.userLocation(fallback: .automatic)
    @State private var visibleRegion = MKCoordinateRegion.init()
    @State private var searchResults = [SearchResult]()
    @State private var selectedLocation: SearchResult?
    @State private var isSearchSheetPresented  = false
    @State private var isInfoSheetPresented = false
    
    var body: some View {
        
//      TODO: should make it so selection can be both selectedLocation and built-in mapFeatures
        Map(position: $position, selection: $selectedLocation) {
            
            ForEach(destinations) { destination in
                Marker(coordinate: destination.coordinate) {
                    Label(destination.name, systemImage: "star")
                            }
                            .tint(.yellow)
            }
            
            ForEach(searchResults) { result in
                if let location = result.mapItem.placemark.location {
                    Marker(coordinate: location.coordinate) {
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
        .onChange(of: selectedLocation) {
            if let selectedLocation {
                isInfoSheetPresented = true
                isSearchSheetPresented = false
                
                position = MapCameraPosition.item(MKMapItem(placemark: selectedLocation.mapItem.placemark))
            } else {
                isInfoSheetPresented = false
            }
        }
        .onChange(of: searchResults) {
            if let firstResult = searchResults.first, searchResults.count == 1 {
                selectedLocation = firstResult
            }
            if !searchResults.isEmpty {
                position = .automatic
                isSearchSheetPresented = false
            } 
        }
        .overlay(alignment: .bottomTrailing) {
            VStack(spacing: 10) {
                if !searchResults.isEmpty {
                    Button {
                        searchResults = []
                        selectedLocation = nil
                    } label: {
                        Image(systemName: "xmark")
                    }
                    .frame(minWidth: 45, minHeight: 45)
                    .background(Color(UIColor.systemBackground))
                    .cornerRadius(5)
                }
                
                Button {
                    isSearchSheetPresented.toggle()
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
        .sheet(isPresented: $isSearchSheetPresented) {
            MapSheetView(searchRegion: $visibleRegion, searchResults: $searchResults)
        }
        .sheet(
            isPresented: $isInfoSheetPresented,
            onDismiss: {
                selectedLocation = nil
            }) {
                if let selectedLocation {
                    LocationInfoView(location: selectedLocation.mapItem)
                }
        }
        .onMapCameraChange(frequency: .onEnd) { newPos in
            visibleRegion = newPos.region
        }
    }
}

#Preview {
    SearchableMapView()
}
