//
//  ConfigurationScene.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit

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
        }
            
    }
}
