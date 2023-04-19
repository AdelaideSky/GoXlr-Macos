//
//  SettingsView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 18/04/2023.
//

import SwiftUI

struct SettingsView: View {    
    @State private var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationSplitView(sidebar: {
            List {
                Text("Settings")
                NavigationLink("Test", destination: {
                    Form {
                        Section {
                            Text("UwU")
                        }
                    }.navigationTitle("Test")
                })
            }.navigationSplitViewColumnWidth(215)
        }, detail: {
            Form {
                Section {
                    Text("Settings")
                }
            }.formStyle(.grouped)
                .navigationSplitViewColumnWidth(500)
                .removeSettingsStyling()
                .clipped()
        }).navigationSplitViewStyle(.balanced)
            .navigationTitle("General")
//            .searchable(text: $searchText, placement: .sidebar, prompt: "Search")
            
    }
}
