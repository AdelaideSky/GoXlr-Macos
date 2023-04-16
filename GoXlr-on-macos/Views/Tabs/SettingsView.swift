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
    @State private var noneString = "none"
    
    @ObservedObject var userSettings = Config()
    @State private var audioReminder = false

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
                    Button("Run Audio Setup") {
                        audioReminder = true
                    }.alert("What is the model of your GoXlr ?", isPresented: $audioReminder) {
                        Button("Cancel", role: .cancel) {
                            audioReminder = false
                        }
                        Button("Mini", role: .destructive) {
                            audioReminder = AudioSetup(model: .Mini)
                        }
                        Button("Full", role: .destructive) {
                            audioReminder = AudioSetup(model: .Full)
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
                    Picker("Fader 2", selection: userSettings.onScreenFader1 == "none" ? $noneString : $userSettings.onScreenFader2) {
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
                
                Section(header: Text("Quick routing")) {
                    HStack {
                        Text("Route 1")
                        VStack {
                            Picker("", selection: $userSettings.Route1in) {
                                Group {
                                    Text("None").tag("none")
                                    Text("Mic").tag("Microphone")
                                    Text("Line-In").tag("LineIn")
                                    Text("Console").tag("Console")
                                    Text("System").tag("System")}
                                Group {
                                    Text("Game").tag("Game")
                                    Text("Chat").tag("Chat")
                                    Text("Samples").tag("Samples")
                                    Text("Music").tag("Music")}
                            }.padding(.bottom, 5)
                                .onChange(of: userSettings.Route1in) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: "Route1in")
                                }
                            Picker("", selection: userSettings.Route1in == "none" ? $noneString : $userSettings.Route1out) {
                                Group {
                                    Text("None").tag("none")
                                    Text("Headphones").tag("Headphones")
                                    Text("Broadcast Mix").tag("BroadcastMix")
                                    Text("Line-Out").tag("LineOut")
                                    Text("Chat Mic").tag("ChatMic")
                                    Text("Sampler").tag("Sampler")}
                                
                            }.disabled(userSettings.Route1in == "none" ? true : false)
                                .onChange(of: userSettings.Route1out) { newValue in
                                    UserDefaults.standard.set(newValue, forKey: "Route1out")
                                }
                        }
                    }
                    if userSettings.Route1in != "none" {
                        if userSettings.Route1out != "none" {
                            HStack {
                                Text("Route 2")
                                VStack {
                                    Picker("", selection: userSettings.Route1out == "none" ? $noneString : $userSettings.Route2in) {
                                        Group {
                                            Text("None").tag("none")
                                            Text("Mic").tag("Microphone")
                                            Text("Line-In").tag("LineIn")
                                            Text("Console").tag("Console")
                                            Text("System").tag("System")}
                                        Group {
                                            Text("Game").tag("Game")
                                            Text("Chat").tag("Chat")
                                            Text("Samples").tag("Samples")
                                            Text("Music").tag("Music")}
                                    }.padding(.bottom, 5)
                                        .onChange(of: userSettings.Route2in) { newValue in
                                            UserDefaults.standard.set(newValue, forKey: "Route2in")
                                        }
                                    Picker("", selection: userSettings.Route2in == "none" ? $noneString : $userSettings.Route2out) {
                                        Group {
                                            Text("None").tag("none")
                                            Text("Headphones").tag("Headphones")
                                            Text("Broadcast Mix").tag("BroadcastMix")
                                            Text("Line-Out").tag("LineOut")
                                            Text("Chat Mic").tag("ChatMic")
                                            Text("Sampler").tag("Sampler")}
                                        
                                    }.disabled(userSettings.Route2in == "none" ? true : false)
                                        .onChange(of: userSettings.Route2out) { newValue in
                                            UserDefaults.standard.set(newValue, forKey: "Route2out")
                                        }
                                }
                            }
                            
                            if userSettings.Route2in != "none" {
                                if userSettings.Route2out != "none" {
                                    HStack {
                                        Text("Route 3")
                                        VStack {
                                            
                                            Picker("", selection: userSettings.Route2out == "none" ? $noneString : $userSettings.Route3in) {
                                                Group {
                                                    Text("None").tag("none")
                                                    Text("Mic").tag("Microphone")
                                                    Text("Line-In").tag("LineIn")
                                                    Text("Console").tag("Console")
                                                    Text("System").tag("System")}
                                                Group {
                                                    Text("Game").tag("Game")
                                                    Text("Chat").tag("Chat")
                                                    Text("Samples").tag("Samples")
                                                    Text("Music").tag("Music")}
                                            }.padding(.bottom, 5)
                                                .onChange(of: userSettings.Route3in) { newValue in
                                                    UserDefaults.standard.set(newValue, forKey: "Route3in")
                                                }
                                            Picker("", selection: userSettings.Route3in == "none" ? $noneString : $userSettings.Route3out) {
                                                Group {
                                                    Text("None").tag("none")
                                                    Text("Headphones").tag("Headphones")
                                                    Text("Broadcast Mix").tag("BroadcastMix")
                                                    Text("Line-Out").tag("LineOut")
                                                    Text("Chat Mic").tag("ChatMic")
                                                    Text("Sampler").tag("Sampler")}
                                                
                                            }.disabled(userSettings.Route3in == "none" ? true : false)
                                                .onChange(of: userSettings.Route3out) { newValue in
                                                    UserDefaults.standard.set(newValue, forKey: "Route3out")
                                                }
                                        }
                                    }
                                }
                            }
                        }
                    }
                    
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
