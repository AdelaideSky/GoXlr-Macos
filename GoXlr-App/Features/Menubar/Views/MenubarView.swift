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
    @ObservedObject var configuration = AppSettings.shared.menubar
    
    var body: some View {
        VStack {
            ForEach(configuration.enabledModules, id:\.self) { module in
                VStack {
                    HStack {
                        Text(module.rawValue)
                            .font(.subheadline)
                            .bold()
                        Spacer()
                    }.padding(.bottom, -3)
                    Group {
                        switch module {
                        case .profiles:
                            ProfilesMenubarModule()
                        case .faders:
                            FadersMenubarModule()
                        case .routing:
                            RoutingMenubarModule()
                        default:
                            Text(module.rawValue)
                        }
                    }.frame(maxWidth: .infinity)
                        .background {
                            EffectsView(material: NSVisualEffectView.Material.hudWindow, blendingMode: NSVisualEffectView.BlendingMode.behindWindow)
//                                .blur(radius: 2)
                                .brightness(-0.1)
//                                .opacity(0.2)
                                .mask {
                                    RoundedRectangle(cornerRadius: 10).fill(.gray)
                                }
                                .shadow(radius: 2)
                        }
                }.padding(.bottom, 5)
            }
            HStack {
                
                Button() {
                    goxlr.stopObserving()
                    NSApplication.shared.terminate(nil)
                } label: {
                    Label("Power", systemImage: "power").foregroundColor(.primary)
                }.keyboardShortcut("q")
                
                Button(action: {
                    openWindow(id: "configure")
                    NSApp.setActivationPolicy(.regular)
                    let window = NSApp.windows.first { $0.identifier?.rawValue == "configure" }!
                    window.orderFrontRegardless()
                }, label: {
                    Text("Configure GoXlr")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
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
            .foregroundColor(.primary)
    }
}
