//
//  SearchCompletionInformation.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/6/26.
//

import Foundation

struct SearchCompletionInformation: Hashable, Identifiable {
    let id = UUID()
    let title: String
    let subtitle: String
}
