//
//  SearchCompletionView.swift
//  TwoWheels
//
//  Created by Jonathan Irving on 4/6/26.
//

import SwiftUI

struct SearchCompletionView: View {
    let completionInfo: SearchCompletionInformation

    var body: some View {
        VStack(alignment: .leading) {
            HStack {
                Image(systemName: "mappin")

                VStack(alignment: .leading) {
                    Text(completionInfo.title)
                        .font(.title3)

                    if !completionInfo.subtitle.isEmpty {
                        Text(completionInfo.subtitle)
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
            }
        }
    }
}

#Preview {
    let info = SearchCompletionInformation(title: "Lane Stadium", subtitle: "We suck at football")
    SearchCompletionView(completionInfo: info)
}
