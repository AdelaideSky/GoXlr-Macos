//
//  FadersMixerElements.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 19/04/2023.
//

import SwiftUI
import GoXlrKit

struct FadersRowMixerElement: View {
    
    @ObservedObject var faderStatus = GoXlr.shared.mixer!.faderStatus
    
    var body: some View {
        Section("Faders") {
            HStack {
                Spacer(minLength: 0)
                FadersMixerElement(fader: .A, channelAssignation: $faderStatus.a.channel, muteFunction: $faderStatus.a.muteType)
                FadersMixerElement(fader: .B, channelAssignation: $faderStatus.b.channel, muteFunction: $faderStatus.b.muteType)
                FadersMixerElement(fader: .C, channelAssignation: $faderStatus.c.channel, muteFunction: $faderStatus.c.muteType)
                FadersMixerElement(fader: .D, channelAssignation: $faderStatus.d.channel, muteFunction: $faderStatus.d.muteType)
                Spacer(minLength: 0)
            }
        }
    }
}

struct FadersMixerElement: View {
    
    @State var fader: FaderName
    
    @Binding var channelAssignation: ChannelName
    @Binding var muteFunction: MuteFunction
    
    var body: some View {
        VStack {
            Form {
                Section("Fader \(fader.rawValue)") {
                    Picker("Channel", selection: $channelAssignation) {
                        ForEach(ChannelName.allCases, id: \.self) { value in
                            Text(value.displayName).tag(value)
                        }
                    }
                    Picker("Mute", selection: $muteFunction) {
                        Text("All").tag(MuteFunction.All)
                        Text("To stream").tag(MuteFunction.ToStream)
                        Text("To voice chat").tag(MuteFunction.ToVoiceChat)
                        Text("To phones").tag(MuteFunction.ToPhones)
                        Text("To line-out").tag(MuteFunction.ToLineOut)
                    }
                }
            }.formStyle(.grouped)
                .padding(-10)
        }.frame(maxWidth: 250)
    }
}
