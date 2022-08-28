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
                
                OpenWindowButton()
                    
            }.menuBarExtraStyle(.window)
                

            
        }
}



struct OpenWindowButton: View {
    @Environment(\.openWindow) private var openWindow
    @State private var select = ""
    @ObservedObject var mixer = MixerStatus()
    @State private var advanced = false
    
    
    
    let profiletype = UTType(filenameExtension: "goxlr")
    
        var body: some View {
            
            VStack(spacing: 16) {
                ZStack {
                    EffectsView(material: NSVisualEffectView.Material.popover, blendingMode: NSVisualEffectView.BlendingMode.behindWindow)
                        .mask {
                            RoundedRectangle(cornerRadius: 10).fill(.gray)
                        }
                        .opacity(1)
                        .shadow(radius: 2)
                    VStack {
                        HStack(alignment: .center, spacing: 5) {
                            MenubarSlider(percentage: $mixer.mic, image: "mic")
                                .onChange(of: mixer.mic) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .Mic, volume: Int(newValue))
                                }
                            Button {
                                print("Muted") } label: {
                                    Label("Mute", systemImage: "mic.slash")
                                        .offset(x: 0.7)
                                        .scaleEffect(1.25)
                                }
                                .clipShape(Circle())
                                .frame(width: 25, height: 22)
                                .scaleEffect(0.81)
                            
                        }.labelStyle(.iconOnly)
                            .padding(10)
                            .controlSize(.large)
                        HStack(alignment: .center, spacing: 5) {
                            MenubarSlider(percentage: $mixer.linein, image: "chevron.backward.to.line")
                                .onChange(of: mixer.linein) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .LineIn, volume: Int(newValue))
                                }
                            Button {
                                print(mixer.linein)
                                mixer.selectedDevice.SetVolume(channel: .LineIn, volume: 0)
                                mixer.linein = 0
                            } label: {
                                    Label("Mute", systemImage: "mic.slash")
                                        .offset(x: 0.7)
                                        .scaleEffect(1.25)
                                }
                                .clipShape(Circle())
                                .frame(width: 25, height: 22)
                                .scaleEffect(0.81)
                            
                        }.labelStyle(.iconOnly)
                            .padding(10)
                            .controlSize(.large)
                    }
                }.padding(.horizontal, 10)
                    .padding(.bottom, 5)
                    
                
                ZStack {
                    EffectsView(material: NSVisualEffectView.Material.popover, blendingMode: NSVisualEffectView.BlendingMode.behindWindow)
                        .mask {
                            RoundedRectangle(cornerRadius: 10).fill(.gray)
                        }
                        .opacity(1)
                        .shadow(radius: 2)
                    VStack {
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
                            
                            Button {
                                mixer.selectedDevice.Sleep() } label: {
                                    Label("Sleep", systemImage: "powersleep")}.keyboardShortcut(.escape)
                            
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
                    
                        .frame(width: 280)
                        .padding(.vertical, 5)
                        
                }.padding(.bottom, 5)
                HStack {
                    Button() {
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
            .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab:"device").environmentObject(mixer)})
            .padding(16)
            .background {
                EffectsView(material: NSVisualEffectView.Material.hudWindow, blendingMode: NSVisualEffectView.BlendingMode.behindWindow)
                    .opacity(1)

            }
            .onDisappear() {
                print("disappear")
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
