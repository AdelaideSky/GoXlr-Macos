//
//  BehavioursSettingsPage.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 30/04/2023.
//

import SwiftUI
import GoXlrKit


struct BehavioursSettingsPage: View {
    @ObservedObject var settings = AppSettings.shared
    
    @State var selection: Int? = nil
    
    var body: some View {
        Form {
            CommandsEditableListView("On app quit",
                                     emptyLabel: "Click the plus icon to add a command that will execute when the app quits !",
                                     list: $settings.shutdownCommands)
            CommandsEditableListView("On Mac sleep",
                                     emptyLabel: "Click the plus icon to add a command that will execute when your mac goes to sleep !",
                                     list: $settings.sleepCommands)
            CommandsEditableListView("On Mac wake-up",
                                     emptyLabel: "Click the plus icon to add a command that will execute when your mac wakes-up !",
                                     list: $settings.wakeCommands)
            
            ButtonPressBehaviours()
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
    }

}
