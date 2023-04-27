//
//  SettingsPages.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 23/04/2023.
//
//  Original code by CodeEdit (CodeEdit on GitHub), modified by Adélaïde Sky

import Foundation
import SwiftUI
import GoXlrKit

struct SettingsPage: Hashable, Identifiable {
    /// Default intializer
    internal init(_ name: Name, baseColor: Color? = nil, icon: IconResource? = nil) {
        self.name = name
        self.baseColor = baseColor ?? .red
        self.icon = icon ?? .system("questionmark.app")
        
        self.deviceUID = nil
        self.deviceModel = nil
    }
    
    internal init(_ deviceUID: String, deviceType: GoXlrModel) {
        self.baseColor = .gray
        self.icon = .system("slider.vertical.3")
        self.deviceUID = deviceUID
        self.deviceModel = deviceType
        
        self.name = nil
    }

    var id: String {
        if let name = name { return name.rawValue }
        else if let deviceUID = deviceUID { return deviceUID }
        else { return "???" }
    }

    let name: Name?
    let deviceUID: String?
    let deviceModel: GoXlrModel?
    let baseColor: Color
    var nameString: LocalizedStringKey {
        if let name = name { return LocalizedStringKey(name.rawValue) }
        else if let deviceUID = deviceUID { return LocalizedStringKey("\(deviceUID) (\(deviceModel!.rawValue))") }
        else { return LocalizedStringKey("???") }
    }
    let icon: IconResource?

    /// A struct for a sidebar icon, with a base color and SF Symbol
    enum IconResource: Equatable, Hashable {
         case system(_ name: String)
        case symbol(_ name: String)
        case asset(_ name: String)
    }

    /// An enum of all the preferences tabs
    enum Name: String {
        // MARK: - App Preferences
        case general = "General"
        case menubar = "Menubar"
        case audio = "Audio"
        case behaviors = "Behaviors"
        case extensions = "Extensions"
    }

}
