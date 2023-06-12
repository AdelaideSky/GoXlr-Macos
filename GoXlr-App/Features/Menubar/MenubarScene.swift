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
            if goxlr.status != nil {
                AppropriateMenubarView()
                    .sentryTrace("Menubar")
            } else {
                NoGoXLRView()
                    .sentryTrace("Menubar_noGoXLR")
            }
        }.menuBarExtraStyle(.window)
        
            
    }
}

struct AppropriateMenubarView: View {
    @ObservedObject var status = GoXlr.shared.status!.data.status
    @ObservedObject var settings = AppSettings.shared

    var body: some View {
        if settings.firstLaunch {
            EmptyView()
        } else {
            if status.mixers.count > 0 {
                MenubarView().frame(width: 305)
            } else {
                NoGoXLRView()
            }
        }
    }
}
