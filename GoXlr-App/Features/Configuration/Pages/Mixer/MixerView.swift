//
//  MixerView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 18/04/2023.
//

import SwiftUI
import GoXlrKit

struct MixerView: View {
    var body: some View {
        VStack {
            ScrollView(showsIndicators: false) {
                ScrollView(.horizontal, showsIndicators: false) {
                    VolumeSlidersRowMixerElement()
                        .frame(height: 380)
                }.scrollContentBackground(.hidden)
                Form {
                    FadersRowMixerElement()
                    CoughButtonView()
                }.formStyle(.grouped)
                    .scrollContentBackground(.hidden)
                    .scrollDisabled(true)
            }
            
        }.navigationTitle("Mixer")
    }
}

struct CoughButtonView: View {
    @ObservedObject var mixer = GoXlr.shared.mixer!
    var body: some View {
        Section("Cough button") {
            Toggle("Toggle behaviour", isOn: $mixer.coughButton.isToggle)
            Picker("Mute", selection: $mixer.coughButton.muteType) {
                Text("All").tag(MuteFunction.All)
                Text("To stream").tag(MuteFunction.ToStream)
                Text("To voice chat").tag(MuteFunction.ToVoiceChat)
                Text("To phones").tag(MuteFunction.ToPhones)
                Text("To line-out").tag(MuteFunction.ToLineOut)
            }
        }
    }
}
