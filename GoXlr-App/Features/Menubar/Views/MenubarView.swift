//
//  MenubarView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import SwiftUI
import GoXlrKit
import SkyKit_Design
import Colorful
import AppKit

struct MenubarView: View {
    
    @ObservedObject var goxlr = GoXlr.shared
    @Environment(\.openWindow) var openWindow
//    @Environment(\.dismissWindow) var dismissWindow
    @ObservedObject var configuration = AppSettings.shared.menubar
    @ObservedObject var lighting = GoXlr.shared.mixer!.lighting
    
    @State var profileColors: [Color] = []
    
    @State var optionKeyPressed: Bool = false
    
    func refreshPColors() {
        var answer = [lighting.simple.accent.colourOne, lighting.faders.a.colours.colourOne, lighting.faders.a.colours.colourTwo]
        if goxlr.mixer?.hardware.deviceType == .Full {
            answer+=[lighting.simple.scribble1!.colourOne, lighting.simple.scribble2!.colourOne, lighting.simple.scribble3!.colourOne, lighting.simple.scribble4!.colourOne, lighting.encoders!.echo!.colourOne]
        }
        profileColors = answer
    }
    

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
                        case .sampler:
                            SamplerMenubarModule()
                        default:
                            Text(module.rawValue)
                        }
                    }.frame(maxWidth: .infinity)
                        .background {
                            EffectsView(material: NSVisualEffectView.Material.hudWindow, blendingMode: NSVisualEffectView.BlendingMode.behindWindow)
//                                .blur(radius: 2)
                                .brightness(-0.025)
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
                    //TODO: for macos 14, update this function with commented lines and remove the macos 14- alternatives.
//                    dismissWindow()
                    NSApp.deactivate()
                    openWindow(id: "configure")
                    NSApp.setActivationPolicy(.regular)
                    NSApp.activate(ignoringOtherApps: true)
                    let window = NSApp.windows.first { $0.identifier?.rawValue == "configure" }!
                    window.orderFrontRegardless()
                    window.makeKey()
//                    NSApp.activate()
                }, label: {
                    Text("Configure GoXlr")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                }).keyboardShortcut(";")
                
                //ShareLink(items: ["SharingContent"])
                
                Menu {
                    
//                        TODO: For macos 14, replace custom button by SettingsLink (showSettingsWindow: doesn't work on 14+ )

//                    SettingsLink {
//                        Label("Settings", systemImage: "gear")
//                            .labelStyle(.titleOnly)
//                    }
                    
                    Button(action: {
                        NSApp.sendAction(Selector(("showSettingsWindow:")), to: nil, from: nil)
                    }, label: {
                        Label("Settings", systemImage: "gear")
                            .labelStyle(.titleOnly)
                    })
                    
                    Link("Open GoXLR-Utility's WebUI", destination: URL(string: "http://localhost:14564/")!)
                    Link("Join support server", destination: URL(string: "https://discord.gg/cyavp8F2WW")!)
                    Menu("Debug") {
                        Button("Reload Daemon") {
                            goxlr.daemon.restart(args:[.noMenubarIcon])
                        }
                        Button("Copy debug info") {
                            goxlr.copyDebugInfo()
                        }
                        Picker("Log level", selection: $goxlr.logLevel) {
                            Text("None").tag(GoXlr.GoXlrLogLevel.none)
                            Text("Info").tag(GoXlr.GoXlrLogLevel.info)
                            Text("Debug").tag(GoXlr.GoXlrLogLevel.debug)
                        }
                    }
                    
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
                ZStack {
                    EffectsView(material: .hudWindow, blendingMode: .behindWindow)
                    VStack {
                        AngularGradient(colors: profileColors, center: .top, angle: .degrees(-180))
                            .frame(height: 50)
                            .blur(radius: 100)
                            .onChange(of: goxlr.mixer!.profileName) { _ in
                                refreshPColors()
                            }
                            .onAppear {
                                refreshPColors()
                            }
                        
                            .animation(.easeInOut(duration: 1), value: profileColors)
                        Spacer()
                    }
                    
                    SKNoiseTexture()
                        .opacity(0.05)
                }
            }
            .foregroundColor(.primary)
    }
}
