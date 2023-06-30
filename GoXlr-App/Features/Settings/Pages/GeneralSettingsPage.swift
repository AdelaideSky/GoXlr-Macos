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
            UpdaterSettingsView()
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
                HStack {
                    Text("Recover defaults for...")
                    Spacer()
                    Menu("Profiles", content: {
                        Button("Profiles") { GoXlr.shared.command(.RecoverDefaults(.Profiles))}
                        Button("Mic profiles") { GoXlr.shared.command(.RecoverDefaults(.MicProfiles))}
                        Button("Icons") { GoXlr.shared.command(.RecoverDefaults(.Icons))}
                        Button("Presets") { GoXlr.shared.command(.RecoverDefaults(.Presets))}
                    }, primaryAction: {
                        GoXlr.shared.command(.RecoverDefaults(.Profiles))
                    }).menuStyle(.borderlessButton)
                        .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.secondary)
                                    .opacity(0.7)
                            )
                        .fixedSize()
                }
            }
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
    }
}
