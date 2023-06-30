//
//  SettingsScene.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit
import SentrySwiftUI

struct SettingsScene: Scene {
    var body: some Scene {
        Settings {
            AppropriateSettingsView()
        }.windowStyle(.automatic)
            .windowToolbarStyle(.unified)
            .windowResizability(.contentSize)
    }
}
struct AppropriateSettingsView: View {
    @ObservedObject var goxlr = GoXlr.shared
    var body: some View {
        if goxlr.status != nil {
            SettingsView()
                .frame(minWidth: 715, maxWidth: 715, minHeight: 400)
                .sentryTrace("Settings")
        } else {
            Text("Please connect your GoXlr !")
        }
    }
}
