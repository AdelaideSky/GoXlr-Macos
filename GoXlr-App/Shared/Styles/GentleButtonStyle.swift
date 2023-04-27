//
//  GentleButtonStyle.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 22/04/2023.
//

import Foundation
import SwiftUI

struct GentleFlippingButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .rotationEffect(Angle(degrees: configuration.isPressed ? 90 : 0))
            .clipShape(RoundedRectangle(cornerRadius: 5))
            .padding(4)
            .aspectRatio(1, contentMode: .fill)
            .background {
                Color.gray
                    .opacity(configuration.isPressed ? 0.2 : 0)
            }
            .cornerRadius(5)
            .symbolVariant(configuration.isPressed ? .fill : .none)
            .animation(.interactiveSpring(), value: configuration.isPressed)
    }
}

extension ButtonStyle where Self == GentleFlippingButtonStyle {
    static var gentleFlipping: Self { Self() }
}

struct GentleButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
            .padding(4)
            .background {
                Color.gray
                    .opacity(configuration.isPressed ? 0.2 : 0)
            }
            .cornerRadius(5)
            .symbolVariant(configuration.isPressed ? .fill : .none)
    }
}

extension ButtonStyle where Self == GentleButtonStyle {
    static var gentle: Self { Self() }
}
