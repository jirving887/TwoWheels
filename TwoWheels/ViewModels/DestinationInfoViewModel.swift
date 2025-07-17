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
    private let onEdit: () -> Void
    private let onUnPin: () -> Void

    var isDirectionsSheetPresented = false
    var isDirectionsAlertPresented = false
    var route: MKRoute?

    init(
        directionsService: any Directing,
        onEdit: @escaping () -> Void,
        onUnPin: @escaping () -> Void
    ) {
        self.directionsService = directionsService
        self.onEdit = onEdit
        self.onUnPin = onUnPin
    }

    func showDirections(to destination: Destination) async {
        let destinationPlacemark = MKPlacemark(coordinate: destination.coordinate)
        let destinationItem = MKMapItem(placemark: destinationPlacemark)
        let request = MKDirections.Request()
        request.source = try? await directionsService.getUserMapItem()
        request.destination = destinationItem
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
