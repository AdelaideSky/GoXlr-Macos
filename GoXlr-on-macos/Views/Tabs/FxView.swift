//
//  FxView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 29/08/2022.
//

import Foundation
import SwiftUI

struct FxView: View {
    @State var tabname: String? = "Effects"
    @EnvironmentObject var mixer: MixerStatus
    
    @State private var selectedPreset: String = "Preset1"
    
    @State private var toggle1 = false
    @State private var toggle2 = true


    var body: some View {
        VStack(alignment: .center) {
            Text("chalu")
        }.navigationTitle(tabname!)
            .padding(.top, 1)
            .onAppear() {
                mixer.updateSlidersLightning()
            }
            .onChange(of: selectedPreset) { newValue in
                mixer.selectedDevice.SetActiveFXPreset(preset: selectedPreset)
            }
            .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab: "device").environmentObject(mixer)})
            .toolbar {
                ToolbarItemGroup(placement:.automatic) {
                    Button(action: {mixer.profileSheet.toggle()}, label: {
                        Text("Load Profile")
                    })
                    Spacer()
                    Button(action: {MixerStatus().selectedDevice.SaveProfile()}, label: {
                        Text("Save Profile")
                    })
                }
                ToolbarItem(placement:.automatic) {
                    Text("　　　  ")
                }
                
                ToolbarItemGroup(placement:.automatic) {
                    Picker("Preset", selection: $selectedPreset){
                        Text(" 1 ").tag("Preset1")
                        Text(" 2 ").tag("Preset2")
                        Text(" 3 ").tag("Preset3")
                        Text(" 4 ").tag("Preset4")
                        Text(" 5 ").tag("Preset5")
                        Text(" 6 ").tag("Preset6")
                    }.pickerStyle(.segmented)
                }
            }

    }
}
