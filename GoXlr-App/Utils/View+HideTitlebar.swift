//
//  View+HideTitlebar.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI

extension View {
    func removeSettingsStyling() -> some View {
        modifier(RemoveSettingsStyling())
    }
    func configureWindowStyle() -> some View {
        modifier(ConfigureWindowStyle())
    }
}

struct RemoveSettingsStyling: ViewModifier {
    func body(content: Content) -> some View {
        content
            .task {
                let window = NSApp.windows.first { $0.identifier?.rawValue == "com_apple_SwiftUI_Settings_window" }!
                window.titleVisibility = .visible
                window.toolbarStyle = .automatic
                window.titlebarAppearsTransparent = true
                
//                let sidebaritem = "com.apple.SwiftUI.navigationSplitView.toggleSidebar"
//                let index = window.toolbar?.items.firstIndex { $0.itemIdentifier.rawValue == sidebaritem }
//                if let index {
//                    window.toolbar?.removeItem(at: index)
//                }
            }
    }
}
struct ConfigureWindowStyle: ViewModifier {
    func body(content: Content) -> some View {
        content
            .task {
                let window = NSApp.windows.first { $0.identifier?.rawValue == "configure" }!
                window.titleVisibility = .visible
                window.titlebarAppearsTransparent = true
            }
    }
}
