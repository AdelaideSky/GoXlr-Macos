//
//  GenderFXModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 22/04/2023.
//

import SwiftUI
import GoXlrKit

struct GenderFXModule: View {
    @ObservedObject var current = GoXlr.shared.mixer!.effects!.current
        
    @FocusState var amountFocused: Bool
    
    var body: some View {
        Section("Gender") {
            Picker("Style", selection: $current.gender.style) {
                Text("Narrow").tag(GenderStyle.Narrow)
                Text("Medium").tag(GenderStyle.Medium)
                Text("Wide").tag(GenderStyle.Wide)
            }
            HStack(alignment: .center) {
                Text("Amount")
                Spacer()
                Slider(value: $current.gender.amount, in: -25...25).controlSize(.small)
                Divider()
                TextField(value: $current.gender.amount, format: .rounded, label: {})
                    .textFieldStyle(.plain)
                    .font(.system(.body))
                    .foregroundColor(.secondary)
                    .frame(width: 25)
                    .offset(y: -2.5)
                    .focused($amountFocused)
                    .onSubmit {
                        amountFocused.toggle()
                    }
            }
        }
    }
}
