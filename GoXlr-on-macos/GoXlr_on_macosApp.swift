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
    func applicationDidFinishLaunching(_ notification: Notification) {
        xpc_set_event_stream_handler("com.apple.iokit.matching", nil) { event in
            let name = xpc_dictionary_get_string(event, XPC_EVENT_KEY_NAME)
            let id = xpc_dictionary_get_uint64(event, "IOMatchLaunchServiceID")
            print("Received event: \(name), \(id)")
        }
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


