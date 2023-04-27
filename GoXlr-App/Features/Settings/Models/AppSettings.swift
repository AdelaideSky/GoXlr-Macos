//
//  AppSettings.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 23/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit
import ServiceManagement

class AppSettings: ObservableObject {
    
    static var shared: AppSettings {
        return AppSettings()
    }
    
    @State var menubar = MenubarConfiguration.shared
    
    @State var mmodsSettings = MenubarModulesSettings()
    
    @AppStorage(AppSettingsKeys.launchAtStartup.rawValue)
    var launchAtStartup: Bool = false {
        didSet {
            let service = SMAppService.mainApp
            do {
                if launchOnConnect { try service.register() }
                else { try service.unregister() }
            } catch { }
        }
    }
    
    @AppStorage(AppSettingsKeys.launchOnConnect.rawValue)
    var launchOnConnect: Bool = false {
        didSet {
            GoXlr.shared.utils.toggleLaunchOnConnectAgent(launchAtStartup)
        }
    }
}

class MenubarModulesSettings: ObservableObject {
    @Published var faders = FadersMenubarModuleConfig()
    var routing = RoutingMenubarModuleConfig()
}

enum AppSettingsKeys: String {
    case launchAtStartup = "fr.adesky.goxlr.launchAtStartup"
    case launchOnConnect = "fr.adesky.goxlr.launchOnConnect"
    case menubarModules = "fr.adesky.goxlr.menubarModules"
    
    case mmodFaders_Fader1 = "fr.adesky.goxlr.menubarFaders.1"
    case mmodFaders_Fader2 = "fr.adesky.goxlr.menubarFaders.2"
    case mmodFaders_Fader3 = "fr.adesky.goxlr.menubarFaders.3"
    
    case mmodRouter_Route1 = "fr.adesky.goxlr.menubarRouter.1"
    case mmodRouter_Route2 = "fr.adesky.goxlr.menubarRouter.2"
    case mmodRouter_Route3 = "fr.adesky.goxlr.menubarRouter.3"
}
