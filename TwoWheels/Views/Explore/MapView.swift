//
//  MapView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/24/24.
//

import MapKit
import SwiftData
import SwiftUI

struct MapView: View {
    @Environment(ExploreViewModel.self) var viewModel
    
    let manager = CLLocationManager()
    
    var body: some View {
        @Bindable var viewModel = viewModel
        MapReader { proxy in
            Map(position: $viewModel.position, selection: $viewModel.selectedDestination) {
                ForEach(viewModel.destinations) { destination in
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
                
                ForEach(viewModel.tappedLocations) { location in
                    Marker(coordinate: location.coordinate) {
                        Image(systemName: "mappin")
                    }
                    .tag(location)
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
                        if let drag,
                           let location = proxy.convert(drag.location, from: .local) {
                            let dragLocation = Destination(
                                latitude: location.latitude,
                                longitude: location.longitude,
                                title: "Unknown Location"
                            )
                            viewModel.addPin(dragLocation)
                        }
                    default:
                        break
                    }
                }
            )
        }
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container: ModelContainer
    do {
        container = try ModelContainer(for: Destination.self, configurations: config)
    } catch {
        fatalError("Failed to create ModelContainer: \(error)")
    }

    let dataService = DataService<Destination>(modelContext: container.mainContext)
    let viewModel = ExploreViewModel(
        dataService: dataService,
        searchService: SearchService(),
        geocoder: CLGeocoder()
    )

    return MapView()
        .modelContainer(container)
        .environment(viewModel)
}
