//
//  MixerView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 18/04/2023.
//

import SwiftUI
import GoXlrKit

struct MixerView: View {
    var body: some View {
        ZStack {
            
            Form {
                Section("Channels") {
                    Spacer().frame(height: 300)
                }
                FadersRowMixerElement()
                
            }.formStyle(.grouped)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
            
            VStack {
                ScrollView(.horizontal, showsIndicators: false) {
                    VolumeSlidersRowMixerElement()
                }.frame(height: 300)
                
                Spacer()
            }.padding(20)
                .padding(.top, 35)
            
        }.navigationTitle("Mixer")
    }
}
