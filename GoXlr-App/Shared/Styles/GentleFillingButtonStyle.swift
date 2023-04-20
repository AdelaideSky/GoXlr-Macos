//
//  GentleFillingButtonStyle.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 20/04/2023.
//

import Foundation
import SwiftUI

struct GentleFillingButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) private var colorScheme
    func makeBody(configuration: Self.Configuration) -> some View {
        VStack {
            Spacer(minLength: 0)
            HStack {
                Spacer(minLength: 0)
                configuration.label
                Spacer(minLength: 0)
            }
            Spacer(minLength: 0)
        }.background {
            Color.gray
                .opacity(configuration.isPressed ? 0.2 : 0.1)
        }
        .cornerRadius(5)
        .symbolVariant(configuration.isPressed ? .fill : .none)
    }
}

extension ButtonStyle where Self == GentleFillingButtonStyle {
    static var gentleFilling: Self { Self() }
}
