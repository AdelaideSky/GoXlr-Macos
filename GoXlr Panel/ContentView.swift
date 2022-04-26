//
//  ContentView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 24/04/2022.
//

import SwiftUI
struct ContentView: View {
    
    private let tabs = ["Control", "Settings"]
    @State private var selectedTab = 0
    
    var body: some View {
        VStack {
            if selectedTab == 0 {
                ControlView()
            }
            if selectedTab == 1 {
                SettingsView()
            }
        }
        .toolbar {
            ToolbarItem(placement: .principal) {
                
                Picker("", selection: $selectedTab) {
                    ForEach(tabs.indices) { i in
                        Text(self.tabs[i]).tag(i)
                    }
                }
                .pickerStyle(SegmentedPickerStyle())
                .padding(.top, 8)
            }
        }
        .frame(minWidth: 800, minHeight: 400)
    }
}
