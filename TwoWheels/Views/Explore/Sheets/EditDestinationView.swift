//
//  EditDestinationView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/23/25.
//

import SwiftUI
import SwiftData
import MapKit

struct EditDestinationView: View {
    @Environment(\.dismiss) private var dismiss

    @State private var viewModel: EditDestinationViewModel

    init(destination: Destination, isSaved: Bool, onSave: @escaping (Destination) -> Void) {
        _viewModel = State(initialValue: EditDestinationViewModel(
            destination: destination,
            isSaved: isSaved,
            onSave: onSave
        ))
    }

    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Name")) {
                    TextField("Destination Name", text: $viewModel.title)
                }
                
                Section(header: Text("Address")) {
                    TextField("Destination Address", text: $viewModel.address, axis: .vertical)
                        .lineLimit(1...5)
                }
            }
            .navigationTitle("\(viewModel.isSaved ? "New" : "Edit") Destination")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItemGroup(placement: .topBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
                
                ToolbarItemGroup(placement: .topBarTrailing) {
                    Button("Save") {
                        viewModel.saveDestination {
                            dismiss()
                        }
                    }
                }
            }
        }
        .alert("A name is required to save a destination.", isPresented: $viewModel.isShowingEmptyTitleAlert) {
            Button("OK", role: .cancel) {}
        }
    }
}

#Preview {
    let laneStadiumDestination = Destination(latitude: 38.22001, longitude: -81.41804, title: "Lane Stadium")

    return EditDestinationView(
        destination: laneStadiumDestination,
        isSaved: false,
        onSave: { _ in }
    )
}
