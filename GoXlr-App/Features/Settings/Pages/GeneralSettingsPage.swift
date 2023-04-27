//
//  GeneralSettingsPage.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 23/04/2023.
//

import SwiftUI
import GoXlrKit

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
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
    }
}
