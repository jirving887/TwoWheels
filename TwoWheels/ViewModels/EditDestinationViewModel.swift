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
    private let destination: Destination
    private let onSave: (Destination) -> Void

    var title: String
    var address: String
    let isSaved: Bool
    var isShowingEmptyTitleAlert = false

    init(destination: Destination, isSaved: Bool, onSave: @escaping (Destination) -> Void) {
        self.destination = destination
        self.isSaved = isSaved
        self.onSave = onSave
        title = destination.title
        address = destination.address
    }

    func saveDestination(onSuccess: () -> Void) {
        let emptyTitle = title.trimmingCharacters(in: .whitespaces).isEmpty
        isShowingEmptyTitleAlert = emptyTitle
        if !emptyTitle {
            save()
            onSuccess()
        }
    }

    private func save() {
        destination.title = title
        destination.address = address
        if !isSaved {
            onSave(destination)
        }
    }
}
