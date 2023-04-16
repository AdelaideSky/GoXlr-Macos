//
//  GoXlr_AppApp.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 27/12/2022.
//

import SwiftUI
import GoXlrKit

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationDidFinishLaunching(_ notification: Notification) {
        GoXlr.shared.startObserving()
    }
    func applicationWillTerminate(_ notification: Notification) {
        GoXlr.shared.stopObserving()
    }
}

@main
struct GoXlr_AppApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
