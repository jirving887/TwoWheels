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
    
    @State private var position = MapCameraPosition.userLocation(fallback: .automatic)
    @State private var visibleRegion = MKCoordinateRegion.init()
    @State private var searchResults = [Destination]()
    @State private var selectedLocation: Destination?
    @State private var isSearchSheetPresented  = false
    @State private var isInfoSheetPresented = false
    
    var body: some View {
        
        Map(position: $position, selection: $selectedLocation) {
            
            ForEach(destinations) { destination in
                Marker(coordinate: destination.coordinate) {
                        Label(destination.title, systemImage: "star")
                    }
                    .tint(.yellow)
            }
            
            ForEach(searchResults) { result in
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
        .onChange(of: selectedLocation) {
            if let selectedLocation, itemIsValid(selectedLocation.mapItem) {
                isInfoSheetPresented = true
                isSearchSheetPresented = false
                
                if let item = selectedLocation.mapItem {
                    position = MapCameraPosition.item(item)
                }
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
                    LocationInfoView(location: selectedLocation)
                }
        }
        .onMapCameraChange(frequency: .onEnd) { newPos in
            visibleRegion = newPos.region
        }
    }
    
    private func itemIsValid(_ item: MKMapItem?) -> Bool {
        
        let emptyCoordinates = CLLocationCoordinate2D.init()
        
        if let item {
            if item.placemark.coordinate.latitude != emptyCoordinates.latitude ||
                item.placemark.coordinate.longitude != emptyCoordinates.longitude {
                return true
            }
        }
        return false
    }
}

#Preview {
    SearchableMapView()
}
