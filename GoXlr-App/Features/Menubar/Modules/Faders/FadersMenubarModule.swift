//
//  FadersMenubarModule.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 24/04/2023.
//

import SwiftUI
import GoXlrKit

struct FadersMenubarModule: View {
    @ObservedObject var configuration = AppSettings.shared.mmodsSettings.faders
    var body: some View {
        VStack {
            FaderMenubarItem(configuration.fader1)
            if configuration.fader2 != nil {
                FaderMenubarItem(configuration.fader2!)
                    .padding(.top, 5)
                
                if configuration.fader3 != nil {
                    FaderMenubarItem(configuration.fader3!)
                        .padding(.top, 5)
                }
            }
        }.padding(.vertical)
    }
}
struct FaderMenubarItem: View {
    @ObservedObject var levels = GoXlr.shared.mixer!.levels
    
    var channel: ChannelName
    
    init(_ channel: ChannelName) {
        self.channel = channel
    }
    
    var body: some View {
        Group {
            switch channel {
            case .Mic:
                HVolumeSlider(value: $levels.volumes.mic, image: channel.icon)
            case .LineIn:
                HVolumeSlider(value: $levels.volumes.lineIn, image: channel.icon)
            case .Console:
                HVolumeSlider(value: $levels.volumes.console, image: channel.icon)
            case .System:
                HVolumeSlider(value: $levels.volumes.system, image: channel.icon)
            case .Game:
                HVolumeSlider(value: $levels.volumes.game, image: channel.icon)
            case .Chat:
                HVolumeSlider(value: $levels.volumes.chat, image: channel.icon)
            case .Sample:
                HVolumeSlider(value: $levels.volumes.sample, image: channel.icon)
            case .Music:
                HVolumeSlider(value: $levels.volumes.music, image: channel.icon)
            case .Headphones:
                HVolumeSlider(value: $levels.volumes.headphones, image: channel.icon)
            case .MicMonitor:
                HVolumeSlider(value: $levels.volumes.micMonitor, image: channel.icon)
            case .LineOut:
                HVolumeSlider(value: $levels.volumes.lineOut, image: channel.icon)
            }
        }
    }
}
