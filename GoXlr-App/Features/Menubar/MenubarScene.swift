//
//  MenubarScene.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit

struct MenubarScene: Scene {
    var body: some Scene {
        MenuBarExtra("GoXlr App", image: "devices.goxlr.logo") {
            AppropriateMenubarView()
        }.menuBarExtraStyle(.window)
    }
}

struct AppropriateMenubarView: View {
    @ObservedObject var goxlr = GoXlr.shared
    var body: some View {
        if goxlr.status?.data.status.mixers.count ?? 0 > 0 {
            MenubarView().frame(width: 305)
        } else {
            NoGoXLRView()
        }
    }
}
