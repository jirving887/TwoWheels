//
//  ExploreViewModelProtocol.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/6/26.
//

import Foundation
import _MapKit_SwiftUI

protocol ExploreViewModelProtocol: AnyObject, Observable {
    associatedtype MapLocation: Hashable

    var mapPosition: MapCameraPosition { get set }
    var mapSelection: MapSelection<MapLocation>? { get set }
    var visibleRegion: MKCoordinateRegion? { get set }
    var searchText: String { get set }
    var selectedLocation: MapLocation { get set }
    var isShowingDetailSheet: Bool { get set }

    func search()
    func didDismissDetailSheet()
}
