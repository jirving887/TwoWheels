//
//  ExploreViewModel.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/28/25.
//

import Foundation

@Observable
class ExploreViewModel {
    private let dataService: DataService
    
    var selectedTab: TabSelection = .map
    
    init(dataService: DataService) {
        self.dataService = dataService
    }
}
