//
//  ExploreViewModelProtocol.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/6/26.
//

import Foundation
import _MapKit_SwiftUI

protocol ExploreViewModelProtocol: AnyObject, Observable {
    var mapPosition: MapCameraPosition { get set }
    var mapSelection: MapSelection<Location>? { get set }
    var visibleRegion: MKCoordinateRegion { get set }
    var searchText: String { get set }
    var selectedLocation: Location? { get }
    var isShowingDetailSheet: Bool { get set }
    var searchCompletions: [SearchCompletionInformation] { get }

    func search()
    func didDismissDetailSheet()
}
