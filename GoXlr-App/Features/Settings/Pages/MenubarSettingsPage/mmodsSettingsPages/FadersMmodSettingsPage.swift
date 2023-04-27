//
//  FadersMmodSettingsPage.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 26/04/2023.
//

import SwiftUI
import GoXlrKit

struct FadersMmodSettingsPage: View {
    @ObservedObject var settings = AppSettings.shared.mmodsSettings.faders
    var body: some View {
        Form {
            Section("Channels") {
                Picker("Channel 1", selection: $settings.fader1) {
                    ForEach(ChannelName.allCases, id:\.rawValue) { channel in
                        Text(channel.rawValue).tag(channel)
                    }
                }
                Picker("Channel 2", selection: $settings.fader2) {
                    ForEach(ChannelName.allCases.filter({$0 != settings.fader1}), id:\.rawValue) { channel in
                        Text(channel.rawValue).tag(channel as ChannelName?)
                    }
                    Text("None").tag(nil as ChannelName?)
                }
                if settings.fader2 != nil {
                    Picker("Channel 3", selection: $settings.fader3) {
                        ForEach(ChannelName.allCases.filter({$0 != settings.fader1 && $0 != settings.fader2}), id:\.rawValue) { channel in
                            Text(channel.rawValue).tag(channel as ChannelName?)
                        }
                        Text("None").tag(nil as ChannelName?)
                    }
                }
            }
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .animation(.default, value: settings.fader2)
    }
}

struct FadersMmodSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        FadersMmodSettingsPage()
    }
}
