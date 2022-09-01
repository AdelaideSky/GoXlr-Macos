//
//  SettingsView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 29/08/2022.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers
import ServiceManagement

struct SettingsView: View {
    @State var tabname: String? = "Settings"
    @State private var bebu = "none"
    @State private var bebu2 = "none"
    
    @ObservedObject var userSettings = Config()

    @EnvironmentObject var mixer: MixerStatus
    var body: some View {
        VStack(alignment: .center) {
            
            Form {
                Section(header: Text("General")) {
                    Toggle("Launch at startup", isOn: $userSettings.launchAtStartup)
                        .toggleStyle(.switch)
                        .onChange(of: userSettings.launchAtStartup) { newValue in
                            let service = SMAppService.mainApp
                            do {
                                if newValue {
                                    try service.register()
                                }
                                else {
                                    try service.unregister()
                                }
                            } catch {
                                
                            }
                        }
                    Toggle("Launch on device connect", isOn: $userSettings.launchOnConnect)
                        .toggleStyle(.switch)
                        .onChange(of: userSettings.launchOnConnect) { newValue in
                            let service = SMAppService.agent(plistName: "com.adesky.goxlr.autolaunch.plist")
                            do {
                                if newValue {
                                    try service.register()
                                }
                                else {
                                    try service.unregister()
                                }
                            } catch {
                                
                            }
                        }
                }
                Section(header: Text("On-screen faders")) {
                    Picker("Fader 1", selection: $userSettings.onScreenFader1) {
                        Group {
                            Text("None").tag("none")
                            Text("Mic").tag("mic")
                            Text("LineIn").tag("linein")
                            Text("Console").tag("console")
                            Text("System").tag("system")}
                        Group {
                            Text("Game").tag("game")
                            Text("Chat").tag("chat")
                            Text("Sample").tag("sample")
                            Text("Music").tag("music")}
                        Group {
                            Text("Headphones").tag("headphones")
                            Text("MicMonitor").tag("micmonitor")
                            Text("LineOut").tag("lineout")
                            Text("Bleep").tag("bleep")}
                    }.onChange(of: userSettings.onScreenFader1) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "onScreenFader1")
                    }
                    Picker("Fader 2", selection: $userSettings.onScreenFader2) {
                        Group {
                            Text("None").tag("none")
                            Text("Mic").tag("mic")
                            Text("LineIn").tag("linein")
                            Text("Console").tag("console")
                            Text("System").tag("system")}
                        Group {
                            Text("Game").tag("game")
                            Text("Chat").tag("chat")
                            Text("Sample").tag("sample")
                            Text("Music").tag("music")}
                        Group {
                            Text("Headphones").tag("headphones")
                            Text("MicMonitor").tag("micmonitor")
                            Text("LineOut").tag("lineout")
                            Text("Bleep").tag("bleep")}
                    }.onChange(of: userSettings.onScreenFader2) { newValue in
                        UserDefaults.standard.set(newValue, forKey: "onScreenFader2")
                    }
                    .disabled(userSettings.onScreenFader1 == "none" ? true : false)
                }
            }.padding(.horizontal, 200)
                .formStyle(.grouped)
            
        }
            .navigationTitle(tabname!)
            .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab: "device").environmentObject(mixer)})
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {mixer.profileSheet.toggle()}, label: {
                        Text("Load Profile")
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {MixerStatus().selectedDevice.SaveProfile()}, label: {
                        Text("Save Profile")
                    })
                }
            }
                
    }
}
