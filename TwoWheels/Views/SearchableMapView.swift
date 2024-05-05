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
    @State private var isSearchSheetPresented: Bool = false
    @State private var isInfoSheetPresented: Bool = false

    
    var body: some View {
            
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
                    isInfoSheetPresented = true
                    isSearchSheetPresented = false
                    
                    position = MapCameraPosition.item(MKMapItem(placemark: MKPlacemark(coordinate: selectedLocation.location)))
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
                    MapSheetView(searchResults: $searchResults)
                })
                .frame(minWidth: 45, minHeight: 45)
                .background(Color(UIColor.systemBackground))
                .cornerRadius(5)
                .padding(.trailing, 5)
                .padding(.bottom, 20)
            }
            .sheet(isPresented: $isInfoSheetPresented, content: {
                LocationInfoView(location: selectedLocation ?? SearchResult(location: CLLocationCoordinate2D(latitude: 37.65729684192488, longitude: -77.1791187289185), title: "Preview Title", subTitle: "Preview subtitle", url: URL(string: "URL")))
            })
    }
}

#Preview {
    SearchableMapView()
}


