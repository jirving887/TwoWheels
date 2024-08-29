//
//  SearchableMapView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/24/24.
//

import MapKit
import SwiftUI

struct SearchableMapView: View {
    
    @State private var position = MapCameraPosition.userLocation(fallback: .automatic)
    @State private var visibleRegion: MKCoordinateRegion?
    @State private var searchResults = [SearchResult]()
    @State private var selectedLocation: SearchResult?
    @State private var isSearchSheetPresented = false
    @State private var isInfoSheetPresented = false
    
    var body: some View {
        
//      should make it so selection can be both selectedLocation and built-in mapFeatures
        Map(position: $position, selection: $selectedLocation) {
            ForEach(searchResults) { result in
                //force unwrap of location ok because a SearchResult object is never initialized without one
                Marker(coordinate: result.mapItem.placemark.location!.coordinate) {
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
        .mapFeatureSelectionDisabled { _ in false }
        .mapFeatureSelectionContent { feature in
            Marker(feature.title ?? "", coordinate: feature.coordinate)
                .tag(feature)
        }
        .mapControlVisibility(.visible)
        .onChange(of: selectedLocation) {
            print("changed selectedlocation")
            if let selectedLocation {
                isInfoSheetPresented = true
                isSearchSheetPresented = false
                
                //force unwrap of location ok because a SearchResult object is never initialized without one
                position = MapCameraPosition.item(MKMapItem(placemark: MKPlacemark(coordinate: selectedLocation.mapItem.placemark.location!.coordinate)))
            } else {
                isInfoSheetPresented = false
            }
        }
        .onChange(of: searchResults) {
            if let firstResult = searchResults.first, searchResults.count == 1 {
                selectedLocation = firstResult
            }
            if (!searchResults.isEmpty) {
                position = .automatic
            } else {
                position = MapCameraPosition.userLocation(fallback: .automatic)
            }
        }
        .overlay(alignment: .bottomTrailing) {
            Button {
                isSearchSheetPresented.toggle()
            } label: {
                    Image(systemName: "magnifyingglass")
            }
            .sheet(isPresented: $isSearchSheetPresented, content: {
                MapSheetView(searchRegion: visibleRegion, searchResults: $searchResults)
            })
            .frame(minWidth: 45, minHeight: 45)
            .background(Color(UIColor.systemBackground))
            .cornerRadius(5)
            .padding(.trailing, 5)
            .padding(.bottom, 20)
        }
        .sheet(isPresented: $isInfoSheetPresented, content: {
            if let selectedLocation {
                LocationInfoView(location: selectedLocation.mapItem)
            }
            
        })
        .onMapCameraChange { newPos in
            visibleRegion = newPos.region
        }
    }
}

#Preview {
    SearchableMapView()
}


