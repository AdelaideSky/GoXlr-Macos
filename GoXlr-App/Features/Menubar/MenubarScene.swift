//
//  MenubarScene.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 17/04/2023.
//

import Foundation
import SwiftUI
import GoXlrKit
import SentrySwiftUI

struct MenubarScene: Scene {
    @ObservedObject var goxlr = GoXlr.shared
    
    var body: some Scene {
        MenuBarExtra("GoXlr App", image: "devices.goxlr.logo") {
            AppropriateMenubarView()
                .sentryTrace("Menubar")
        }.menuBarExtraStyle(.window)
        
            
    }
}

struct AppropriateMenubarView: View {
    @ObservedObject var goxlr = GoXlr.shared
    @ObservedObject var settings = AppSettings.shared

    var body: some View {
        if settings.firstLaunch {
            EmptyView()
        } else {
            if goxlr.status?.data.status.mixers.count ?? 0 > 0 {
                MenubarView().frame(width: 305)
            } else {
                NoGoXLRView()
            }
        }
    }
}
