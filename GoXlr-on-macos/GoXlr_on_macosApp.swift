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
        print("orjeng")
            guard
                urls.count == 1,
                let videoUrl = urls.first
            else {
                print("oejn")
                return

            }
        }
    func applicationWillTerminate(_ notification: Notification) {
        Daemon().stop()
    }
    
}
@main
struct GoXlr_on_macosApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    let deviceCountRefreshTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    @State var deviceCount = GoXlr().numberDevices()
        var body: some Scene {
            Settings {
                AppropriateSettingsView()
            }
            MenuBarExtra("GoXlr-App", image: "devices.goxlr.logo") {
                
                AppropriateMenuView()
                    
            }.menuBarExtraStyle(.window)
                
            
        }
}

struct AppropriateMenuView: View {
    @State var deviceCount = GoXlr().numberDevices()
    let deviceCountRefreshTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    var body: some View {
        if deviceCount < 1 {
            NullView()
                .onReceive(deviceCountRefreshTimer) { input in
                    deviceCount = GoXlr().numberDevices()
                }
            
        } else {
            MenubarView(mixer: MixerStatus()).frame(width: 305)
        }
    }
}

struct AppropriateSettingsView: View {
    @State var deviceCount = GoXlr().numberDevices()
    let deviceCountRefreshTimer = Timer.publish(every: 10, on: .main, in: .common).autoconnect()
    var body: some View {
        if deviceCount < 1 {
            NullView()
                .onReceive(deviceCountRefreshTimer) { input in
                    deviceCount = GoXlr().numberDevices()
                }
        } else {
            ContentView(mixer: MixerStatus())
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

struct AutoCloseView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        Text("fjb").onAppear() {
            print("erkhb")
            presentationMode.wrappedValue.dismiss()
        }
        .frame(width: 50, height: 50)
    }
}

