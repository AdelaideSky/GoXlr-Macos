//
//  ProminentButtonStyle.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 08/05/2023.
//

import SwiftUI


struct SecondaryProminentButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .font(.subheadline)
            .padding(15)
            .background {
                Color.secondary
                    .opacity(configuration.isPressed ? 0.5 : 0.001)
            }
            .cornerRadius(10)
            .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(.secondary, lineWidth: 1)
            )
            .symbolVariant(configuration.isPressed ? .fill : .none)
    }
}

extension ButtonStyle where Self == SecondaryProminentButtonStyle {
    static var secondaryProminent: Self { Self() }
}
