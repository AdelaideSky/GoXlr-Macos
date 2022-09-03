//
//  menubarView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 29/08/2022.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers


struct MenubarView: View {
    @Environment(\.openWindow) private var openWindow
    @State private var select = ""
    @ObservedObject var mixer = MixerStatus()
    @State private var advanced = false
    let settingsRefreshTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    
    @ObservedObject var userSettings = Config()

    
    let profiletype = UTType(filenameExtension: "goxlr")
    
        var body: some View {
            
            VStack(alignment: .center, spacing: 20) {
                if userSettings.onScreenFader1 != "none" {
                    ZStack {
                        EffectsView(material: NSVisualEffectView.Material.popover, blendingMode: NSVisualEffectView.BlendingMode.behindWindow)
                            .mask {
                                RoundedRectangle(cornerRadius: 10).fill(.gray)
                            }
                            .opacity(1)
                            .shadow(radius: 2)
                        
                        VStack(alignment: .center, spacing: 3) {
                            Text("Volumes")
                                .font(.headline)
                                .scaleEffect(0.9)
                                .padding(.top, 5)
                                .padding(.right, 200)
                            if userSettings.onScreenFader1 == "mic" {OnscreenSliderView(channel: .Mic, value: $mixer.mic, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "linein" {OnscreenSliderView(channel: .LineIn, value: $mixer.linein, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "console" {OnscreenSliderView(channel: .Console, value: $mixer.console, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "system" {OnscreenSliderView(channel: .System, value: $mixer.system, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "game" {OnscreenSliderView(channel: .Game, value: $mixer.game, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "chat" {OnscreenSliderView(channel: .Chat, value: $mixer.chat, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "sample" {OnscreenSliderView(channel: .Sample, value: $mixer.sample, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "music" {OnscreenSliderView(channel: .Music, value: $mixer.music, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "headphones" {OnscreenSliderView(channel: .Headphones, value: $mixer.headphones, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "micmonitor" {OnscreenSliderView(channel: .MicMonitor, value: $mixer.micmonitor, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "lineout" {OnscreenSliderView(channel: .LineOut, value: $mixer.lineout, mixer: mixer)}
                            else if userSettings.onScreenFader1 == "bleep" {OnscreenSliderView(channel: .Bleep, value: $mixer.bleep, mixer: mixer)}
                            
                            if userSettings.onScreenFader2 != "none" {
                                if userSettings.onScreenFader2 == "mic" {OnscreenSliderView(channel: .Mic, value: $mixer.mic, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "linein" {OnscreenSliderView(channel: .LineIn, value: $mixer.linein, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "console" {OnscreenSliderView(channel: .Console, value: $mixer.console, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "system" {OnscreenSliderView(channel: .System, value: $mixer.system, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "game" {OnscreenSliderView(channel: .Game, value: $mixer.game, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "chat" {OnscreenSliderView(channel: .Chat, value: $mixer.chat, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "sample" {OnscreenSliderView(channel: .Sample, value: $mixer.sample, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "music" {OnscreenSliderView(channel: .Music, value: $mixer.music, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "headphones" {OnscreenSliderView(channel: .Headphones, value: $mixer.headphones, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "micmonitor" {OnscreenSliderView(channel: .MicMonitor, value: $mixer.micmonitor, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "lineout" {OnscreenSliderView(channel: .LineOut, value: $mixer.lineout, mixer: mixer)}
                                else if userSettings.onScreenFader2 == "bleep" {OnscreenSliderView(channel: .Bleep,value: $mixer.bleep, mixer: mixer)}
                            }
                        }
                        
                    }.padding(.horizontal, 10)
                        .frame(height: userSettings.onScreenFader2 == "none" ? 70 : 90)
                }
                
                if userSettings.Route1in != "none" {
                    if userSettings.Route1out != "none" {
                        ZStack {
                            EffectsView(material: NSVisualEffectView.Material.popover, blendingMode: NSVisualEffectView.BlendingMode.behindWindow)
                                .mask {
                                    RoundedRectangle(cornerRadius: 10).fill(.gray)
                                }
                                .opacity(1)
                                .shadow(radius: 2)
                            
                            VStack(alignment: .center, spacing: 3) {
                                Text("Routing")
                                    .font(.headline)
                                    .scaleEffect(0.9)
                                    .padding(.top, 5)
                                    .padding(.bottom, 15)
                                    .padding(.right, 200)
                                HStack {
                                    
                                    MenubarRoutingView(channelin: InputDevice(rawValue: userSettings.Route1in)!, channelout: OutputDevice(rawValue: userSettings.Route1out)!, mixer: mixer)
                                    if userSettings.Route2in != "none" {
                                        if userSettings.Route2out != "none" {
                                            Divider().padding(.horizontal, 5)
                                            MenubarRoutingView(channelin: InputDevice(rawValue: userSettings.Route2in)!, channelout: OutputDevice(rawValue: userSettings.Route2out)!, mixer: mixer)
                                            if userSettings.Route3in != "none" {
                                                if userSettings.Route3out != "none" {
                                                    Divider().padding(.horizontal, 5)
                                                    MenubarRoutingView(channelin: InputDevice(rawValue: userSettings.Route3in)!, channelout: OutputDevice(rawValue: userSettings.Route3out)!, mixer: mixer)
                                                }
                                            }
                                        }
                                    }
                                }.padding(.bottom, 10)
                                
                            }
                            
                        }.padding(.horizontal, 10)
                            .frame(width: 292, height: 100)
                    }
                }
                    
                
                ZStack {
                    EffectsView(material: NSVisualEffectView.Material.popover, blendingMode: NSVisualEffectView.BlendingMode.behindWindow)
                        .mask {
                            RoundedRectangle(cornerRadius: 10).fill(.gray)
                        }
                        .opacity(1)
                        .shadow(radius: 2)
                    VStack(alignment: .center, spacing: 3) {
                        Text("Profiles")
                            .font(.headline)
                            .scaleEffect(0.9)
                            .padding(.top, 5)
                            .padding(.right, 210)
                        VStack(alignment: .center, spacing: 3) {
                            HStack {
                                
                                
                                Menu("Mic profile") {
                                    
                                    ForEach(mixer.micProfilesList, id: \.self) { profile in
                                        Button(profile) {
                                            mixer.selectedDevice.LoadMicProfile(path: profile)
                                        }
                                        
                                    }
                                    
                                }.keyboardShortcut("o")
                                Button {
                                    mixer.selectedDevice.SaveProfile()} label: {
                                    Text("Save Mic Profile")
                                        .frame(maxWidth: .infinity)}
                                
                                
                            }.labelStyle(.iconOnly)
                            .controlSize(.large)
                            .padding(.vertical, 5)

                            HStack {
                                
                                Toggle(isOn: !$mixer.routerMic[0]) {
                                    ZStack {
                                        Label("Mute mic monitor", systemImage: "mic.and.signal.meter.fill")
                                        if !mixer.routerMic[0] {
                                            Image(systemName: "line.diagonal")
                                                .scaleEffect(1.7)
                                        }
                                    }
                                }.toggleStyle(.button)
                                .onChange(of: mixer.routerMic[0]) { newValue in
                                    _ = mixer.selectedDevice.SetRouter(inputDevice: .Microphone, outputDevice: .Headphones, state: newValue)
                                }

                                
                                Button {
                                    mixer.selectedDevice.SaveProfile()} label: {
                                    Text("Save Profile")
                                        .frame(maxWidth: .infinity)}.keyboardShortcut("s")
                                Menu("Quick load") {
                                    
                                    ForEach(mixer.profilesList, id: \.self) { profile in
                                        Button(profile) {
                                            mixer.selectedDevice.LoadProfile(path: profile)
                                        }
                                        
                                    }
                                    
                                }.keyboardShortcut("o")
                                

                            }.labelStyle(.iconOnly)
                            .controlSize(.large)
                            .padding(.vertical, 5)
                            
                        }.padding(.horizontal, 10)
                        
                            .frame(width: 270)
                            .padding(.vertical, 5)
                    }
                        
                }.padding(.bottom, 5)
                    .padding(.top, userSettings.onScreenFader1 == "none" ? 15 : 0)
                    .frame(height: 100)
                
                HStack {
                    Button() {
                        Daemon().stop()
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Label("Power", systemImage: "power")}.keyboardShortcut("q")
                    Button {
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)} label: {
                        Text("Configure GoXlr")
                            .frame(maxWidth: .infinity)}.keyboardShortcut(";")

                    //ShareLink(items: ["SharingContent"])
                    
                    Menu {
                        Button("Reload Daemon") {
                            Daemon().restart(args:[])
                        }
                        Button("Copy debug info") {
                            GoXlr().copyDebugInfo()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                    }
                    .menuIndicator(.hidden)
                    .frame(width: 30)
                    
                    
                }
                
                .labelStyle(.iconOnly)
                .controlSize(.large)
            }
            .padding(.top, 5)
            .onReceive(settingsRefreshTimer) { input in
                userSettings.refreshOSFaders()
            }
            .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab:"device").environmentObject(mixer)})
            .padding(16)

            .background {
                EffectsView(material: NSVisualEffectView.Material.hudWindow, blendingMode: NSVisualEffectView.BlendingMode.behindWindow)
                    .opacity(1)

            }
        }
}

// blur effect
struct EffectsView: NSViewRepresentable {
    var material: NSVisualEffectView.Material
    var blendingMode: NSVisualEffectView.BlendingMode

    func makeNSView(context: Context) -> NSVisualEffectView {
        let visualEffectView = NSVisualEffectView()
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
        visualEffectView.state = NSVisualEffectView.State.active
        return visualEffectView
    }

    func updateNSView(_ visualEffectView: NSVisualEffectView, context: Context) {
        visualEffectView.material = material
        visualEffectView.blendingMode = blendingMode
    }
}

prefix func ! (value: Binding<Bool>) -> Binding<Bool> {
    Binding<Bool>(
        get: { !value.wrappedValue },
        set: { value.wrappedValue = !$0 }
    )
}
