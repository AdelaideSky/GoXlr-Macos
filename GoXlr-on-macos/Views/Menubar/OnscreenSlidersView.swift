//
//  OnscreenSlidersView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 29/08/2022.
//

import Foundation
import SwiftUI

struct OnscreenSliderView: View {
    let channel: OnscreenFaderChannelName
    @Binding var value: Float
    @ObservedObject var mixer: MixerStatus
    
    var body: some View {
        VStack(alignment: .center) {
            VStack {
                HStack(alignment: .center, spacing: 5) {
                    if channel != .Bleep {
                        MenubarSlider(percentage: $value, image: channel.icon())
                            .opacity(value < 1 ? 0.7 : 1)
                            .onChange(of: value) { newValue in
                                mixer.selectedDevice.SetVolume(channel: ChannelName(rawValue: channel.rawValue)!, volume: Int(newValue))
                            }
                    }
                    else {
                        MenubarSlider(percentage: $value, image: BleepName.Bleep.icon())
                            .opacity(value < 1 ? 0.7 : 1)
                            .onChange(of: value) { newValue in
                                mixer.selectedDevice.SetSwearButtonVolume(volume: Int(Double(newValue)/255*34-34))
                            }

                    }
                    
                }.labelStyle(.iconOnly)
                    .padding(10)
                    .controlSize(.large)
            }
        }
    }
}
