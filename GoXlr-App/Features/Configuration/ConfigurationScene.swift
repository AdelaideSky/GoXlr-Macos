//
//  ConfigurationScene.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit
import SentrySwiftUI

struct ConfigurationScene: Scene {
    @ObservedObject var goxlr = GoXlr.shared
    var body: some Scene {
        Window("Configure your GoXLR", id: "configure") {
            VStack {
                if goxlr.status?.data.status.mixers.count ?? 0 > 0 {
                    ZStack {
                        EffectsView(material: .menu, blendingMode: .behindWindow).ignoresSafeArea()
                        NavigationView()
                            .configureWindowStyle()
                    }
                } else {
                    ZStack {
                        EffectsView(material: .menu, blendingMode: .behindWindow).ignoresSafeArea()
                        LoadingElement()
                    }
                }
            }.frame(minWidth: 1000, idealWidth: 1100, minHeight: 600, idealHeight: 620)
                .sentryTrace("Configuration")
        }.commands {
            if let status = goxlr.status {
                if status.data.status.mixers.count > 1 {
                    CommandMenu("Device") {
                        Picker("Device", selection: $goxlr.device) {
                            ForEach(goxlr.status!.data.status.mixers.sorted(), id:\.key) { mixer in
                                Text("\(mixer.0) (\(mixer.1.hardware.deviceType.rawValue))").tag(mixer.0)
                            }
                        }.pickerStyle(.inline)
                    }
                }
            }
        }
            
    }
}
