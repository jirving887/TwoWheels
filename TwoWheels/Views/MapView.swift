//
//  MapView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 1/5/24.
//
import CoreLocation
import MapKit
import SwiftUI

struct MapView: View {
    
    @EnvironmentObject var destinations: Destinations
    
    @State private var coordinatesFromAddress: CLLocationCoordinate2D?
    @State private var isCoordinateAvailable = false
    @State private var addressToGeocode = "1600 Amphitheatre Parkway, Mountain View, CA"
    

       
    var body: some View {
        
        Map { //Reference: https://developer.apple.com/videos/play/wwdc2023/10043/ If this doesn't work, fallback: https://www.youtube.com/watch?v=hWMkimzIQoU
            ForEach(destinations.places) {destination in
                if let coordinates = coordinatesFromAddress {
                    Annotation(destination.name, coordinate: coordinates) {
                        ZStack {
                            RoundedRectangle(cornerRadius: 5)
                                .fill(.background)
                            RoundedRectangle(cornerRadius: 5)
                                .stroke(Color.secondary, lineWidth: 5)
                            Image(systemName: "house.and.flag")
                                .padding(5)
                        }
                    }
                }
            }
            if let coordinates = coordinatesFromAddress {
                Annotation("Home", coordinate: coordinates) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 5)
                            .fill(.background)
                        RoundedRectangle(cornerRadius: 5)
                            .stroke(Color.secondary, lineWidth: 5)
                        Image(systemName: "house.and.flag")
                            .padding(5)
                    }
                }
            }
            
            Annotation("Home", coordinate: MapDetails.home)
            {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.background)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.secondary, lineWidth: 5)
                    Image(systemName: "house.and.flag")
                        .padding(5)
                }
            }
            
            Annotation("Autism Ranch", coordinate: CLLocationCoordinate2D(latitude: 37.65729684192488, longitude: -77.1791187289185))
            {
                ZStack {
                    RoundedRectangle(cornerRadius: 5)
                        .fill(.background)
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(.secondary, lineWidth: 5)
                    Image(systemName: "house.and.flag")
                        .padding(5)
                }
            }
            UserAnnotation()
        }
        .onAppear {
             self.geocodeAddress()
         }
        .mapStyle(.standard(elevation: .realistic))
        .mapControls {
            MapUserLocationButton()
            MapCompass()
            MapScaleView()
        }
    }
    
    private func geocodeAddress() {
            getCoordinate(addressString: addressToGeocode) { (coordinate, error) in
                DispatchQueue.main.async {
                    if let coordinate = coordinate {
                        coordinatesFromAddress = coordinate
                        isCoordinateAvailable = true
                        print("Latitude: \(coordinate.latitude), Longitude: \(coordinate.longitude)")
                    } else if let error = error {
                        print("Error: \(error.localizedDescription)")
                        isCoordinateAvailable = false
                    }
                }
            }
        }

}

enum MapDetails {
    static let home = CLLocationCoordinate2D(latitude: 38.13005, longitude: -78.20047)
    static let defaultSpan = MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02)
}

#Preview {
    MapView()
        .environmentObject(Destinations())
}

func getCoordinate(addressString: String, completionHandler: @escaping (CLLocationCoordinate2D?, NSError?) -> Void) {
    let geocoder = CLGeocoder()
    geocoder.geocodeAddressString(addressString) { (placemarks, error) in
        if let error = error {
            completionHandler(nil, error as NSError)
            return
        }

        if let placemark = placemarks?.first, let location = placemark.location {
            completionHandler(location.coordinate, nil)
        } else {
            completionHandler(nil, NSError(domain: "com.example.geocoding", code: 1, userInfo: [NSLocalizedDescriptionKey: "Could not determine coordinates for the given address."]))
        }
    }
}


