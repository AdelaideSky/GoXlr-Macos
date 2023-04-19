//
//  SettingsScene.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit

struct SettingsScene: Scene {
    var body: some Scene {
        Settings {
            
            SettingsView()
                .frame(minWidth: 715, maxWidth: 715)
            
        }.windowStyle(.automatic)
            .windowToolbarStyle(.unified)
            .windowResizability(.contentSize)
    }
}
