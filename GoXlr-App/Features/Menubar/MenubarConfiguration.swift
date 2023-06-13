//
//  MenubarConfiguration.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 24/04/2023.
//

import Foundation
import SwiftUI

class MenubarConfiguration: ObservableObject {
    
    static var shared: MenubarConfiguration {
        return MenubarConfiguration()
    }
    
    let availableModules: [MenubarModuleName : MenubarModule] = [
        .profiles: .init(.profiles, description: "Load and save your profiles and mic profiles.", icon: .system("rectangle.on.rectangle.angled"), baseColor: .gray, configurable: false),
        .faders : .init(.faders, description: "Add up to 3 faders that you can modify on the go !", icon: .system("slider.horizontal.3"), baseColor: .indigo, configurable: true),
        .routing : .init(.routing, description: "Choose up to 3 routes that you can toggle at glance !", icon: .system("checklist"), baseColor: .blue, configurable: true),
    ]
    
    @AppStorage(AppSettingsKeys.menubarModules.rawValue) var enabledModules: [MenubarModuleName] = [.profiles, .faders]
    
}

class MenubarModule: ObservableObject {
    
    init(_ name: MenubarModuleName, description: String, icon: IconResource, baseColor: Color, configurable: Bool) {
        self.name = name
        self.description = description
        self.icon = icon
        self.baseColor = baseColor
        self.configurable = configurable
    }
    
    let name: MenubarModuleName
    let description: String
    let icon: IconResource
    let baseColor: Color
    let configurable: Bool
    
    
    enum IconResource: Equatable, Hashable {
         case system(_ name: String)
        case symbol(_ name: String)
        case asset(_ name: String)
    }
}

enum MenubarModuleName: String, Codable {
    case profiles = "Profiles controls"
    case faders = "Quick Mixing"
    case routing = "Quick Routing"
    case defaultControls = "Default controls"
}
