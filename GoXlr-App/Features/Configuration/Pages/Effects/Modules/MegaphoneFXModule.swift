//
//  MegaphoneFXModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 22/04/2023.
//

import SwiftUI
import GoXlrKit

struct MegaphoneFXModule: View {
    @ObservedObject var current = GoXlr.shared.mixer!.effects!.current
    
    @State var showDetails: Bool = false
    
    @FocusState var amountFocused: Bool
    
    var body: some View {
        Section("Megaphone") {
            Picker("Style", selection: $current.megaphone.style) {
                Text("Megaphone").tag(MegaphoneStyle.Megaphone)
                Text("Radio").tag(MegaphoneStyle.Radio)
                Text("On The Phone").tag(MegaphoneStyle.OnThePhone)
                Text("Overdrive").tag(MegaphoneStyle.Overdrive)
                Text("Buzz Cutt").tag(MegaphoneStyle.BuzzCutt)
                Text("Tweed").tag(MegaphoneStyle.Tweed)
            }
            DisclosureGroup("Advanced...", isExpanded: $showDetails) { }
            if showDetails {
                HStack(alignment: .center) {
                    Text("Amount")
                    Spacer()
                    Slider(value: $current.megaphone.amount, in: 0...100).controlSize(.small)
                    Divider()
                    Text(current.megaphone.amount.roundedString)
                        .frame(width: 25)
                        .foregroundColor(.secondary)
                }
                HStack(alignment: .center) {
                    Text("Post-gain")
                    Spacer()
                    Slider(value: $current.megaphone.postGain, in: -20...20).controlSize(.small)
                    Divider()
                    Text(current.megaphone.postGain.roundedString)
                        .frame(width: 25)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
