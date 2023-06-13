//
//  HardTuneFXModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 23/04/2023.
//

import SwiftUI
import GoXlrKit

struct HardTuneFXModule: View {
    @ObservedObject var current = GoXlr.shared.mixer!.effects!.current
        
    @State var showDetails: Bool = false
    @FocusState var amountFocused: Bool
    
    var body: some View {
        Section("Reverb") {
            Picker("Style", selection: $current.hardTune.style) {
                Text("Natural").tag(HardTuneStyle.Natural)
                Text("Medium").tag(HardTuneStyle.Medium)
                Text("Hard").tag(HardTuneStyle.Hard)
            }
            HStack(alignment: .center) {
                Text("Amount")
                Spacer()
                Slider(value: $current.hardTune.amount, in: 0...100).controlSize(.small)
                Divider()
                TextField(value: $current.hardTune.amount, format: .rounded, label: {})
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
            Picker("Source", selection: $current.hardTune.source) {
                Text("All").tag(HardTuneSource.All)
                Text("Music").tag(HardTuneSource.Music)
                Text("System").tag(HardTuneSource.System)
                Text("Game").tag(HardTuneSource.Game)
                Text("Line-In").tag(HardTuneSource.LineIn)
            }
            DisclosureGroup("Advanced...", isExpanded: $showDetails) { }
            if showDetails {
                HStack(alignment: .center) {
                    Text("Rate")
                    Spacer()
                    Slider(value: $current.hardTune.rate, in: 0...100).controlSize(.small)
                    Divider()
                    Text(current.hardTune.rate.roundedString)
                        .frame(width: 25)
                        .foregroundColor(.secondary)
                }
                HStack(alignment: .center) {
                    Text("Window")
                    Spacer()
                    Slider(value: $current.hardTune.window, in: 0...600).controlSize(.small)
                        .padding(.leading, -20)
                    Divider()
                    Text(current.hardTune.window.roundedString)
                        .frame(width: 25)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
