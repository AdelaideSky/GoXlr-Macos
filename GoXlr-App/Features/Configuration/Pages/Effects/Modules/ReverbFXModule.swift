//
//  ReverbFXModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 22/04/2023.
//

import SwiftUI
import GoXlrKit

struct ReverbFXModule: View {
    @ObservedObject var current = GoXlr.shared.mixer!.effects!.current
    
    @State var showDetails: Bool = false
    
    @FocusState var amountFocused: Bool
    
    var body: some View {
        Section("Reverb") {
            Picker("Style", selection: $current.reverb.style) {
                Text("Library").tag(ReverbStyle.Library)
                Text("Dark Bloom").tag(ReverbStyle.DarkBloom)
                Text("Music Club").tag(ReverbStyle.MusicClub)
                Text("Real Plate").tag(ReverbStyle.RealPlate)
                Text("Chapel").tag(ReverbStyle.Chapel)
                Text("Hockey Area").tag(ReverbStyle.HockeyArena)
            }
            HStack(alignment: .center) {
                Text("Amount")
                Spacer()
                Slider(value: $current.reverb.amount, in: 0...100).controlSize(.small)
                Divider()
                TextField(value: $current.reverb.amount, format: .rounded, label: {})
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
            DisclosureGroup("Advanced...", isExpanded: $showDetails) {
                HStack {
                    Spacer()
                    Group {
                        LabelledVSliderElement(label: "Decay", value: $current.reverb.decay, range: 10...20000, unity: "ms")
                        LabelledVSliderElement(label: "Early level", value: $current.reverb.earlyLevel, range: -25...0, unity: "dB")
                        LabelledVSliderElement(label: "Tail level", value: $current.reverb.tailLevel, range: -25...0, unity: "dB")
                        LabelledVSliderElement(label: "Pre-Delay", value: $current.reverb.preDelay, range: 0...100, unity: "ms")
                        LabelledVSliderElement(label: "Lo-Colour", value: $current.reverb.loColour, range: -50...50)
                        LabelledVSliderElement(label: "Hi-Colour", value: $current.reverb.hiColour, range: -50...50)
                        LabelledVSliderElement(label: "Hi-Factor", value: $current.reverb.hiFactor, range: -25...25)
                        LabelledVSliderElement(label: "Diffuse", value: $current.reverb.diffuse, range: -50...50)
                    }.frame(width: 70)
                    Spacer()
                }.frame(height: 300)
            }
            if showDetails {
                HStack(alignment: .center) {
                    Text("Mod-Speed")
                    Spacer()
                    Slider(value: $current.reverb.modSpeed, in: -25...25).controlSize(.small)
                    Divider()
                    Text(current.reverb.modSpeed.roundedString)
                        .frame(width: 25)
                        .foregroundColor(.secondary)
                }
                HStack(alignment: .center) {
                    Text("Mod-Depth")
                    Spacer()
                    Slider(value: $current.reverb.modDepth, in: -25...25).controlSize(.small)
                    Divider()
                    Text(current.reverb.modDepth.roundedString)
                        .frame(width: 25)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
