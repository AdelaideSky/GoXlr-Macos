//
//  GoXlrAppIntents.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 27/06/2023.
//

import Foundation
import AppIntents
import SwiftUI

struct GoXlrAppIntents: AppShortcutsProvider {
    static var appShortcuts: [AppShortcut] {
        AppShortcut(intent: LoadProfileShortcut(), phrases: [
            "Load profile \(\.$profile) in \(.applicationName)"
        ])
    }
    static var shortcutTileColor: ShortcutTileColor { .tangerine }
}
