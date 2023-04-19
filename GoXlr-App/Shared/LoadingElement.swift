//
//  LoadingElement.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI

struct LoadingElement: View {
    var body: some View {
        VStack {
            ProgressView()
                .scaleEffect(0.5)
            Text("LOADING")
                .font(.caption2)
        }.opacity(0.7)
    }
}
