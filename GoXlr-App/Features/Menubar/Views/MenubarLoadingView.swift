//
//  NoGoXLRView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit

struct MenubarLoadingView: View {
    @ObservedObject var goxlr = GoXlr.shared
    var body: some View {
        VStack {
            LoadingElement()
                .padding()
            
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
                    Button("Reload Daemon") {
                        GoXlr.shared.daemon.restart(args: [.noMenubarIcon])
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
            .frame(width: 200)
            .background {
                EffectsView(material: .hudWindow, blendingMode: .behindWindow)
            }
    }
}
