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
    
    @Query private var destinations: [Destination]
    
    @State private var viewModel = SearchableMapViewModel()
    @State private var tappedLocation: CLLocationCoordinate2D? = nil
    
    var body: some View {
        MapReader { proxy in
            Map(position: $viewModel.position, selection: $viewModel.selectedLocation) {
                ForEach(destinations) { destination in
                    Marker(coordinate: destination.coordinate) {
                        Image(systemName: "star")
                    }
                    .tint(.yellow)
                    .tag(destination)
                }
                
                ForEach(viewModel.searchResults) { result in
                    if let item = result.mapItem {
                        Marker(coordinate: item.placemark.coordinate) {
                            Image(systemName: "mappin")
                        }
                        .tag(result)
                    }
                }
                
                if let location = tappedLocation {
                    let placemark = MKPlacemark(coordinate: location)
                    let item = MKMapItem(placemark: placemark)
                    let tappedDestination = Destination(item)
                    Marker(coordinate: location) {
                        Image(systemName: "mappin")
                    }
                    .tag(tappedDestination)
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
            .onMapCameraChange(frequency: .onEnd) { newPos in
                viewModel.visibleRegion = newPos.region
            }
            .gesture(LongPressGesture(minimumDuration: 1)
                .sequenced(before: DragGesture(minimumDistance: 0, coordinateSpace: .local))
                .onEnded { value in
                    switch value {
                    case .second(true, let drag):
                        if let drag {
                            tappedLocation = proxy.convert(drag.location, from: .local)
                        }
                    default:
                        tappedLocation = nil
                    }
                }
            )
        }
        .sheet(isPresented: $viewModel.isSearchSheetPresented) {
            MapSheetView()
        }
        .sheet(isPresented: $viewModel.isInfoSheetPresented) {
            if let location = viewModel.selectedLocation {
                LocationInfoView(location: location)
            }
        }
        .sheet(isPresented: $viewModel.isEditSheetPresented) {
            viewModel.isInfoSheetPresented = true
        } content: {
            if let location = viewModel.selectedLocation {
                EditDestinationView(destination: location, newDestination: true)
            }
        }
        .environment(viewModel)
    }
}

#Preview {
    SearchableMapView()
}
