//
//  GoXlr_on_macosApp.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 02/07/2022.
//

import SwiftUI
import UniformTypeIdentifiers

class AppDelegate: NSObject, NSApplicationDelegate {
    func applicationWillTerminate(_ notification: Notification) {
        Daemon().stop()
    }
}

@main
struct GoXlr_on_macosApp: App {
    @State var currentNumber: String = "oui"
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        var body: some Scene {
            Settings {
                 ContentView()
                    .frame(minWidth: 923, idealWidth: 923, minHeight: 500, idealHeight: 520)
            }
            MenuBarExtra(currentNumber, image: "devices.goxlr.logo") {
                
                MenubarView().frame(width: 305)
                    
            }.menuBarExtraStyle(.window)
                

            
        }
}


