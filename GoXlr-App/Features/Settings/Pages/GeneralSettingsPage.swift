//
//  GeneralSettingsPage.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 23/04/2023.
//

import SwiftUI
import GoXlrKit
import SkyKit_Design
struct GeneralSettingsPage: View {
    @ObservedObject var status = GoXlr.shared.status!.data.status
    @ObservedObject var appSettings = AppSettings.shared
    var body: some View {
        Form {
            Section("App") {
                Toggle("Launch at startup", isOn: $appSettings.launchAtStartup)
                Toggle("Launch on device connect", isOn: $appSettings.launchOnConnect)
            }
            Section("Accessibility") {
                Toggle("TTS on button press", isOn: $status.config.ttsEnabled)
            }
            Section("Advanced") {
                HStack {
                    Text("Reinstall drivers")
                    Spacer()
                    Button(action: {
                        appSettings.initialiseApp()
                    }, label: {
                        Label("Reinstall drivers", systemImage: "chevron.right.circle")
                            .labelStyle(.iconOnly)
                    }).buttonStyle(.gentle)
                        .padding(-5)
                }
            }
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
    }
}
