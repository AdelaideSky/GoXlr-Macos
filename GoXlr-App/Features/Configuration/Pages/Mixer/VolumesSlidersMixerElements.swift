//
//  VolumesSlidersMixerElements.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 19/04/2023.
//

import SwiftUI
import GoXlrKit

struct VolumeSlidersRowMixerElement: View {
    @ObservedObject var levels = GoXlr.shared.mixer!.levels
    
    var body: some View {
        HStack {
            Form {
                Section("Inputs") {
                    HStack {
                        VolumeSliderMixerElement(value: $levels.volumes.mic, channel: .Mic)
                        VolumeSliderMixerElement(value: $levels.volumes.chat, channel: .Chat)
                        VolumeSliderMixerElement(value: $levels.volumes.music, channel: .Music)
                        VolumeSliderMixerElement(value: $levels.volumes.game, channel: .Game)
                        VolumeSliderMixerElement(value: $levels.volumes.console, channel: .Console)

                        VolumeSliderMixerElement(value: $levels.volumes.lineIn, channel: .LineIn)
                        VolumeSliderMixerElement(value: $levels.volumes.system, channel: .System)
                        VolumeSliderMixerElement(value: $levels.volumes.sample, channel: .Sample)
                    }.padding(.vertical)
                }
            }.formStyle(.grouped)
                .scrollDisabled(true)
//            Divider()
//                .padding(.horizontal, 20)
//                .padding(.vertical, 40)
            Form {
                Section("Outputs") {
                    HStack {
                        VolumeSliderMixerElement(value: $levels.volumes.lineOut, channel: .LineOut)
                        VolumeSliderMixerElement(value: $levels.volumes.headphones, channel: .Headphones)
                        VolumeSliderMixerElement(value: $levels.volumes.micMonitor, channel: .MicMonitor)
                    }.padding(.vertical)
                }
            }.formStyle(.grouped)
                .scrollDisabled(true)
        }
    }
}

struct VolumeSliderMixerElement: View {
    
    @Binding var value: Float
    @State var channel: ChannelName
    
    @FocusState var focus: Bool
    
    var body: some View {
        LabelledVSliderElement(label: channel.displayName, value: $value, range: 0...255, icon: channel.icon, unity: "%", formatValue: { value in
            return "\(Int(value/255*100))"
        })
            .frame(width: 90)
    }
}

