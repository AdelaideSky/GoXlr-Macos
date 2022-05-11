//
//  GoXlr_PanelApp.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 24/04/2022.
//

import SwiftUI

class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationWillTerminate(_ aNotification: Notification) {
        print("aha")
        ControlView().Daemon(command: "stop")
    }
}
@main
struct GoXlr_PanelApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }.commands {
            SidebarCommands() // 1
        }
    }
}
