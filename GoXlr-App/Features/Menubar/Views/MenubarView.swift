//
//  MenubarView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import SwiftUI
import GoXlrKit

struct MenubarView: View {
    
    @ObservedObject var goxlr = GoXlr.shared
    @Environment(\.openWindow) var openWindow
    
    var body: some View {
        VStack {
            Spacer()
            HStack {
                
                Button() {
                    goxlr.stopObserving()
                    NSApplication.shared.terminate(nil)
                } label: {
                    Label("Power", systemImage: "power")}.keyboardShortcut("q")
                
                Button(action: {
                    openWindow(id: "configure")
                    NSApp.setActivationPolicy(.regular)
                    let window = NSApp.windows.first { $0.identifier?.rawValue == "configure" }!
                    window.orderFrontRegardless()
                }, label: {
                    Text("Configure GoXlr")
                        .frame(maxWidth: .infinity)
                }).keyboardShortcut(";")
                
                //ShareLink(items: ["SharingContent"])
                
                Menu {
                    Button("Reload Daemon") {
                        goxlr.daemon.restart(args:[.noMenubarIcon])
                    }
                    Button("Copy debug info") {
                        goxlr.copyDebugInfo()
                    }
                    Link("Join support server", destination: URL(string: "https://discord.gg/cyavp8F2WW")!)

                } label: {
                    Image(systemName: "ellipsis")
                }
                .menuIndicator(.hidden)
                .frame(width: 30)
                
            }.labelStyle(.iconOnly)
        }.controlSize(.large)
            .padding(.top, 5)
            .padding(16)
            .background {
                EffectsView(material: .hudWindow, blendingMode: .behindWindow)
            }
    }
}
