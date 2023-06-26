//
//  NoGoXLRView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit
import SkyKit_Design

struct NoGoXLRView: View {
    @ObservedObject var goxlr = GoXlr.shared
    var body: some View {
        VStack {
            if goxlr.status == nil {
                LoadingElement()
                    .padding()
            } else {
                Text("No GoXLR Connected")
                    .padding(.bottom, 15)
                    .font(.system(.body))
            }
            
            HStack {
                Button() {
                    goxlr.stopObserving()
                    NSApplication.shared.terminate(nil)
                } label: {
                    Label("Power", systemImage: "power")
                        .foregroundColor(.primary)
                }.keyboardShortcut("q")
                Spacer()
                Menu {
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
                
            }
            .labelStyle(.iconOnly)
            .controlSize(.large)
        }.padding(16)
            .frame(width: 200)
            .background {
                EffectsView(material: .hudWindow, blendingMode: .behindWindow)
                SKNoiseTexture()
                    .opacity(0.05)
            }
    }
}
