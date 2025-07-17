//
//  ExploreView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import MapKit
import SwiftData
import SwiftUI

struct ExploreView: View {
    @State private var viewModel: ExploreViewModel

    let manager = CLLocationManager()

    init(dataService: any DataManipulating<Destination>) {
        let geocoder = CLGeocoder()
        let viewModel = ExploreViewModel(
            dataService: dataService,
            geocoder: geocoder
        )
        _viewModel = State(initialValue: viewModel)
    }

    var body: some View {
        MapReader { proxy in
            Map(position: $viewModel.position, selection: $viewModel.selectedDestination) {
                ForEach(viewModel.destinations) { destination in
                    if !viewModel.searchResults.contains(destination) {
                        Marker(coordinate: destination.coordinate) {
                            Image(systemName: "star")
                        }
                        .tint(.yellow)
                        .tag(destination)
                    }
                }

                ForEach(viewModel.searchResults) { result in
                    Marker(coordinate: result.coordinate) {
                        Image(systemName: "mappin")
                    }
                    .tag(result)
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

                    if !viewModel.destinations.isEmpty {
                        Button {
                            viewModel.isListSheetPresented.toggle()
                        } label: {
                            Image(systemName: "list.bullet")
                        }
                        .frame(minWidth: 45, minHeight: 45)
                        .background(Color(UIColor.systemBackground))
                        .cornerRadius(5)
                    }
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
        .sheet(isPresented: $viewModel.isSearchSheetPresented) {
            SearchSheetView(region: viewModel.visibleRegion) { viewModel.searchResultsUpdated($0) }
        }
        .sheet(item: $viewModel.editingDestination) {
            viewModel.refreshDestinations()
        } content: {
            EditDestinationView(destination: $0, isSaved: viewModel.isSaved($0)) {
                viewModel.addDestination($0)
            } onDelete: {
                viewModel.deleteDestination($0)
            }
        }
        .sheet(isPresented: $viewModel.isInfoSheetPresented) {
            viewModel.selectedDestination = nil
        } content: {
            if let destination = viewModel.selectedDestination {
                DestinationInfoView(destination: destination, isPin: viewModel.isPin(destination), isSaved: viewModel.isSaved(destination)) {
                    viewModel.editingDestination = destination
                } onUnPin: {
                    viewModel.removePin(destination)
                }
            }
        }
        .sheet(isPresented: $viewModel.isListSheetPresented) {
            DestinationsListView(destinations: viewModel.destinations) { viewModel.selectDestinationFromList($0)
            }
        }
        .alert("Navigation Coming Soon", isPresented: $viewModel.isNavigationAlertPresented) {
            Button("OK", role: .cancel) {}
        }
        .environment(viewModel)
    }
}

#Preview {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container: ModelContainer
    do {
        container = try ModelContainer(for: Destination.self, configurations: config)
    } catch {
        fatalError("Failed to create in-memory container: \(error)")
    }

    let dataService = DataService<Destination>(modelContainer: container)

    return ExploreView(dataService: dataService)
}
