//
//  MixerLightningView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 01/08/2022.
//

import Foundation
import SwiftUI

struct MixerLightningView: View {
    @State var tabname: String? = "Not yet supported"
    @EnvironmentObject var mixer: MixerStatus
    
    @State var rgbTopColour = RGB(r: 0, g: 1, b: 1)
    @State var brightnessTop: CGFloat = 1
    
    @State var rgbBottomColour = RGB(r: 0, g: 1, b: 1)
    @State var brightnessBottom: CGFloat = 1
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                ColourWheel(radius: 150, rgbColour: $mixer.topFaderA, brightness: $mixer.brTopFaderA)
                    .padding(5)
                CustomSlider(rgbColour: $mixer.topFaderA, value: $mixer.brTopFaderA, range: 0.001...1).padding()
                    .onChange(of: mixer.topFaderA.onChangeCompatible()) { newValue in
                        print("top:")
                        print(mixer.topFaderA)
                        print(mixer.topFaderA.toHex())
                        print("\n")
                        mixer.selectedDevice.SetAllFaderColours(colourTop: mixer.topFaderA.toHex(), colourBottom: mixer.bottomFaderA.toHex())
                    }
                Divider()
                ColourWheel(radius: 150, rgbColour: $mixer.bottomFaderA, brightness: $mixer.brBottomFaderA)
                    .padding(5)
                CustomSlider(rgbColour: $mixer.bottomFaderA, value: $mixer.brBottomFaderA, range: 0.001...1).padding()
                    .onChange(of: mixer.bottomFaderA.onChangeCompatible()) { newValue in
                        print("bottom:")
                        print(mixer.bottomFaderA)
                        print(mixer.bottomFaderA.toHex())
                        print("\n")
                        mixer.selectedDevice.SetAllFaderColours(colourTop: mixer.topFaderA.toHex(), colourBottom: mixer.bottomFaderA.toHex())

                    }
            }.frame(width: 200, height: 500)
        }.navigationTitle(tabname!)
            .onAppear() {
                mixer.updateSlidersLightning()
            }
            .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab: "device").environmentObject(mixer)})
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {mixer.profileSheet.toggle()}, label: {
                        Text("Load Profile")
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {MixerStatus().selectedDevice.SaveProfile()}, label: {
                        Text("Save Profile")
                    })
                }
            }

    }
}
