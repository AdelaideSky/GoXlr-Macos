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
    @State var currentNumber: String = "1"
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
        var body: some Scene {
            Settings {
                 ContentView()
                    .frame(minWidth: 923, idealWidth: 923, minHeight: 500, idealHeight: 520)
            }
            MenuBarExtra(currentNumber, image: "devices.goxlr.logo") {
                
                OpenWindowButton()
                
            }.menuBarExtraStyle(.window)
                .commands {
                  CommandMenu("My Top Menu") {
                    Button("Sub Menu Item") { print("You pressed sub menu.") }
                      .keyboardShortcut("S")
                  }
                  CommandGroup(replacing: .pasteboard) {
                    Button("Cut") { print("Cutting something...") }
                      .keyboardShortcut("X")
                    Button("Copy") { print("Copying something...") }
                      .keyboardShortcut("C")
                    Button("Paste") { print("Pasting something...") }
                      .keyboardShortcut("V")
                    Button("Paste and Match Style") { print("Pasting and Matching something...") }
                      .keyboardShortcut("V", modifiers: [.command, .option, .shift])
                    Button("Delete") { print("Deleting something...") }
                      .keyboardShortcut(.delete)
                    Button("Select All") { print("Selecting something...") }
                      .keyboardShortcut("A")
                  }
                }

            
        }
}



struct OpenWindowButton: View {
    @Environment(\.openWindow) private var openWindow
    @State private var select = ""
    @ObservedObject var mixer = MixerStatus()
    @State private var shortcutCount = 1
    let profiletype = UTType(filenameExtension: "goxlr")
    
        var body: some View {
            VStack(spacing: 16) {
                HStack {
                    
                    
                    Menu("Mic profile") {
                        
                        ForEach(MixerStatus().micProfilesList, id: \.self) { profile in
                            Button(profile) {
                                MixerStatus().selectedDevice.LoadMicProfile(path: profile)
                            }
                            
                        }
                        
                    }.keyboardShortcut("o")
                    Button {
                        MixerStatus().selectedDevice.SaveProfile()} label: {
                        Text("Save Mic Profile")
                            .frame(maxWidth: .infinity)}
                    
                    
                }.labelStyle(.iconOnly)
                .controlSize(.large)
                HStack {
                    
                    Button {
                        MixerStatus().selectedDevice.Sleep() } label: {
                            Label("Sleep", systemImage: "powersleep")}.keyboardShortcut(.escape)
                    
                    Button {
                        MixerStatus().selectedDevice.SaveProfile()} label: {
                        Text("Save Profile")
                            .frame(maxWidth: .infinity)}.keyboardShortcut("s")
                    Menu("Quick load") {
                        
                        ForEach(MixerStatus().profilesList, id: \.self) { profile in
                            Button(profile) {
                                MixerStatus().selectedDevice.LoadProfile(path: profile)
                            }
                            
                        }
                        
                    }.keyboardShortcut("o")
                    

                }.labelStyle(.iconOnly)
                .controlSize(.large)
                Spacer(minLength: 0.1)
                HStack {
                    
                    Button {
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)} label: {
                        Text("Configure GoXlr")
                            .frame(maxWidth: .infinity)}.keyboardShortcut(";")

                    //ShareLink(items: ["SharingContent"])
                    Button() {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Label("Power", systemImage: "power")}.keyboardShortcut("q")
                }
                .labelStyle(.iconOnly)
                .controlSize(.large)
            }
            .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab:"device").environmentObject(mixer)})
            
            .padding(16)
        }
}
