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
    let originalTitle: String
    let originalAddress: String
    var title: String
    var address: String
    var isShowingEmptyTitleAlert = false

    init(destination: Destination) {
        originalTitle = destination.title
        originalAddress = destination.address
        title = originalTitle
        address = originalAddress
    }

    func saveDestination() {
        isShowingEmptyTitleAlert = title.isEmpty
    }
}
