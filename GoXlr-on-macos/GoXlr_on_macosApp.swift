//
//  GoXlr_on_macosApp.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 02/07/2022.
//

import SwiftUI
import UniformTypeIdentifiers

class AppDelegate: NSObject, NSApplicationDelegate {
    func application(_ application: NSApplication, open urls: [URL]) {
        print("reviced url: \(urls)")    // << here !!
        if urls.first!.pathExtension == "goxlr" {
            print("handling profile...")
            copyprofile(url: urls.first!, path: .profiles)
            GoXlr(serial: GoXlr().listDevices()[0].first).LoadProfile(path: String(urls.first!.lastPathComponent.dropLast(6)))
        }
        if urls.first!.pathExtension == "goxlrMicProfile" {
            print("handling mic profile...")
            copyprofile(url: urls.first!, path: .micprofiles)
            GoXlr(serial: GoXlr().listDevices()[0].first).LoadMicProfile(path: String(urls.first!.lastPathComponent.dropLast(16)))
        }
        if urls.first!.pathExtension == "preset" {
            print("handling FX preset...")
            copyprofile(url: urls.first!, path: .presets)
            GoXlr(serial: GoXlr().listDevices()[0].first).LoadProfile(path: String(urls.first!.lastPathComponent.dropLast(7)))
        }
    }
}
@main
struct GoXlr_on_macosApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @Environment(\.scenePhase) var scenePhase
    let deviceCountRefreshTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    @ObservedObject var mixer = MixerStatus()
    
    @State var deviceCount = GoXlr().numberDevices()
        var body: some Scene {
            
            Settings {
                AppropriateSettingsView(mixer:mixer)
            }
            MenuBarExtra("GoXlr-App", image: "devices.goxlr.logo") {
                
                AppropriateMenuView(mixer:mixer)
                    
            }.menuBarExtraStyle(.window)
                    
                
            
        }
}

struct AppropriateMenuView: View {
    @ObservedObject var mixer: MixerStatus
    @State var deviceCount = GoXlr().numberDevices()
    let deviceCountRefreshTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    var body: some View {
        if deviceCount < 1 {
            NullView()
                .onReceive(deviceCountRefreshTimer) { input in
                    deviceCount = GoXlr().numberDevices()
                }
            
        } else {
            MenubarView(mixer: mixer).frame(width: 305)
        }
    }
}

struct AppropriateSettingsView: View {
    @ObservedObject var mixer: MixerStatus
    @State var deviceCount = GoXlr().numberDevices()
    let deviceCountRefreshTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    var body: some View {
        if deviceCount < 1 {
            NullView()
                .onReceive(deviceCountRefreshTimer) { input in
                    deviceCount = GoXlr().numberDevices()
                }
        } else {
            ContentView(mixer: mixer)
               .frame(minWidth: 923, idealWidth: 923, minHeight: 500, idealHeight: 520)
               .onReceive(deviceCountRefreshTimer) { input in
                   deviceCount = GoXlr().numberDevices()
               }
        }
    }
}

struct NullView: View {
    var body: some View {
        VStack {
            Text("No GoXlr Connected")
                .padding(.bottom, 15)
                .font(.system(.body))
            HStack {
                Button() {
                    Daemon().stop()
                    NSApplication.shared.terminate(nil)
                } label: {
                    Label("Power", systemImage: "power")}.keyboardShortcut("q")
                    .padding(.right, 70)
                

                //ShareLink(items: ["SharingContent"])
                
                Menu {
                    Button("Reload Daemon") {
                        Daemon().restart(args:[])
                    }
                    Button("Copy debug info") {
                        GoXlr().copyDebugInfo()
                    }
                    Link("Join support server", destination: URL(string: "https://discord.gg/cyavp8F2WW")!)
                } label: {
                    Image(systemName: "ellipsis")
                }
                .menuIndicator(.hidden)
                .frame(width: 30)
                
                
            }
            
            .labelStyle(.iconOnly)
            .controlSize(.large)
        }.padding(16)
        
            .background {
                EffectsView(material: NSVisualEffectView.Material.hudWindow, blendingMode: NSVisualEffectView.BlendingMode.behindWindow)
                    .opacity(1)

            }
    }
}



