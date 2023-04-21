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
        VStack {
            ScrollView(.horizontal, showsIndicators: false) {
                VolumeSlidersRowMixerElement()
                    .frame(height: 380)
            }.scrollContentBackground(.hidden)
            Form {
                FadersRowMixerElement()
                
            }.formStyle(.grouped)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
            
        }.navigationTitle("Mixer")
    }
}
