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
        
    @AppStorage(AppSettingsKeys.firstLaunch.rawValue)
    var firstLaunch: Bool = true
    
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
    
    @AppStorage(AppSettingsKeys.observationStore.rawValue)
    var observationStore: [String:String] = ["Bleep":"testingDeepLinking"]
}

class MenubarModulesSettings: ObservableObject {
    @Published var faders = FadersMenubarModuleConfig()
    var routing = RoutingMenubarModuleConfig()
}

enum AppSettingsKeys: String {
    case firstLaunch = "fr.adesky.goxlr.firstLaunch"
    case launchAtStartup = "fr.adesky.goxlr.launchAtStartup"
    case launchOnConnect = "fr.adesky.goxlr.launchOnConnect"
    case menubarModules = "fr.adesky.goxlr.menubarModules"
    case observationStore = "fr.adesky.goxlr.observationStore"
    
    case mmodFaders_Fader1 = "fr.adesky.goxlr.menubarFaders.1"
    case mmodFaders_Fader2 = "fr.adesky.goxlr.menubarFaders.2"
    case mmodFaders_Fader3 = "fr.adesky.goxlr.menubarFaders.3"
    
    case mmodRouter_Route1 = "fr.adesky.goxlr.menubarRouter.1"
    case mmodRouter_Route2 = "fr.adesky.goxlr.menubarRouter.2"
    case mmodRouter_Route3 = "fr.adesky.goxlr.menubarRouter.3"
}

extension AppSettings {
    func initialiseApp() {
        //  Find Application Support directory
        let fileManager = FileManager.default
        let appSupportURL = fileManager.urls(for: .applicationSupportDirectory, in: .localDomainMask).first!
        
        //  Create subdirectory
        let directoryURL = appSupportURL.appendingPathComponent("fr.adesky.goxlr")
        
        
        //  Create document
        let xpchandler = Bundle.main.url(forResource: "xpchandler", withExtension: "")!
        let xpcHandlerURL = directoryURL.appendingPathComponent("xpchandler")
        
        let initialiser = Bundle.main.url(forResource: "goxlr-initialiser", withExtension: "")!
        let initialiserURL = directoryURL.appendingPathComponent("goxlr-initialiser")
        
        //10000% its possible to simplify this but for now i leave it like this
        let script = """
try
do shell script \"sudo mkdir \\\"\(directoryURL.path)\\\"\" with administrator privileges
end try
try
do shell script \"sudo cp \\\"\(xpchandler.path)\\\" \\\"\(xpcHandlerURL.path)\\\"\" with administrator privileges
end try
try
do shell script \"sudo cp \\\"\(initialiser.path)\\\" \\\"\(initialiserURL.path)\\\"\" with administrator privileges
end try
try
do shell script \"\(initialiserURL.path)\"
end try
"""
        NSAppleScript(source: script)!.executeAndReturnError(nil)
        
        GoXlr.shared.utils.registerInitAgents()
        
    }
}
