//
//  DestinationInfoViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 7/14/25.
//

import Foundation
import MapKit

@MainActor
@Observable
class DestinationInfoViewModel {
    private let directionsService: any Directing
    private let destination: Destination
    private let onEdit: () -> Void
    private let onUnPin: () -> Void

    var isDirectionsSheetPresented = false
    var isDirectionsAlertPresented = false
    var route: MKRoute?

    init(
        directionsService: any Directing,
        destination: Destination,
        onEdit: @escaping () -> Void,
        onUnPin: @escaping () -> Void
    ) {
        self.directionsService = directionsService
        self.destination = destination
        self.onEdit = onEdit
        self.onUnPin = onUnPin
    }

    func showDirections() async {
        let placemark = MKPlacemark(coordinate: destination.coordinate)
        let destination = MKMapItem(placemark: placemark)
        let request = MKDirections.Request()
        request.source = try? await directionsService.getUserMapItem()
        request.destination = destination
        do {
            route = try await directionsService.getDirections(with: request)
        } catch {
            print("Could not get directions, error: \(error)")
            isDirectionsAlertPresented = true
            isDirectionsSheetPresented = false
            return
        }
        isDirectionsAlertPresented = false
        isDirectionsSheetPresented = true
    }

    func edit() {
        onEdit()
    }

    func removePin() {
        onUnPin()
    }
}
