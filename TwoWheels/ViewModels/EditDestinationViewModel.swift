//
//  EditDestinationViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 7/12/25.
//

import Foundation

@MainActor
@Observable
class EditDestinationViewModel {
    private let dataService: any DataManipulating<Destination>
    private let destination: Destination

    var title: String
    var address: String
    var isShowingEmptyTitleAlert = false

    init(destination: Destination, dataService: any DataManipulating<Destination>) {
        self.destination = destination
        self.dataService = dataService
        title = destination.title
        address = destination.address
    }

    func saveDestination() {
        isShowingEmptyTitleAlert = title.isEmpty
        if !title.isEmpty {
            save()
        }
    }

    private func save() {
        destination.title = title
        destination.address = address
        if !dataService.fetch().contains(destination) {
            dataService.add(destination)
        }
    }
}
