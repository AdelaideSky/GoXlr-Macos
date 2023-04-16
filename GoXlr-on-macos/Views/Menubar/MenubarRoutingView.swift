//
//  MenubarRouting.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 03/09/2022.
//

import Foundation
import SwiftUI
struct MenubarRoutingView: View {
    let channelin: InputDevice
    let channelout: OutputDevice
    @ObservedObject var mixer: MixerStatus
    
    var body: some View {
        if channelin == .Microphone {
            if channelout == .Headphones {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerMic[1], mixer: mixer)}
            else if channelout == .BroadcastMix {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerMic[3], mixer: mixer)}
            else if channelout == .LineOut {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerMic[0], mixer: mixer)}
            else if channelout == .ChatMic {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerMic[2], mixer: mixer)}
            else if channelout == .Sampler {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerMic[4], mixer: mixer)}
        }
        else if channelin == .Chat {
            if channelout == .Headphones {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerChat[1], mixer: mixer)}
            else if channelout == .BroadcastMix {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerChat[3], mixer: mixer)}
            else if channelout == .LineOut {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerChat[0], mixer: mixer)}
            else if channelout == .Sampler {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerChat[4], mixer: mixer)}
        }
        else if channelin == .Music {
            if channelout == .Headphones {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerMusic[1], mixer: mixer)}
            else if channelout == .BroadcastMix {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerMusic[3], mixer: mixer)}
            else if channelout == .LineOut {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerMusic[0], mixer: mixer)}
            else if channelout == .ChatMic {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerMusic[2], mixer: mixer)}
            else if channelout == .Sampler {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerMusic[4], mixer: mixer)}
        }
        else if channelin == .Game {
            if channelout == .Headphones {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerGame[1], mixer: mixer)}
            else if channelout == .BroadcastMix {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerGame[3], mixer: mixer)}
            else if channelout == .LineOut {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerGame[0], mixer: mixer)}
            else if channelout == .ChatMic {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerGame[2], mixer: mixer)}
            else if channelout == .Sampler {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerGame[4], mixer: mixer)}
        }
        else if channelin == .Console {
            if channelout == .Headphones {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerConsole[1], mixer: mixer)}
            else if channelout == .BroadcastMix {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerConsole[3], mixer: mixer)}
            else if channelout == .LineOut {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerConsole[0], mixer: mixer)}
            else if channelout == .ChatMic {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerConsole[2], mixer: mixer)}
            else if channelout == .Sampler {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerConsole[4], mixer: mixer)}
        }
        else if channelin == .LineIn {
            if channelout == .Headphones {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerLineIn[1], mixer: mixer)}
            else if channelout == .BroadcastMix {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerLineIn[3], mixer: mixer)}
            else if channelout == .LineOut {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerLineIn[0], mixer: mixer)}
            else if channelout == .ChatMic {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerLineIn[2], mixer: mixer)}
            else if channelout == .Sampler {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerLineIn[4], mixer: mixer)}
        }
        else if channelin == .System {
            if channelout == .Headphones {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerSystem[1], mixer: mixer)}
            else if channelout == .BroadcastMix {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerSystem[3], mixer: mixer)}
            else if channelout == .LineOut {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerSystem[0], mixer: mixer)}
            else if channelout == .ChatMic {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerSystem[2], mixer: mixer)}
            else if channelout == .Sampler {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerSystem[4], mixer: mixer)}
        }
        else if channelin == .Samples {
            if channelout == .Headphones {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerSamples[1], mixer: mixer)}
            else if channelout == .BroadcastMix {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerSamples[3], mixer: mixer)}
            else if channelout == .LineOut {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerSamples[0], mixer: mixer)}
            else if channelout == .ChatMic {MenubarCheckboxRoutingView(channelin: channelin, channelout: channelout, state: $mixer.routerSamples[2], mixer: mixer)}
        }
    }
}
struct MenubarCheckboxRoutingView: View {
    let channelin: InputDevice
    let channelout: OutputDevice
    @Binding var state: Bool
    var mixer: MixerStatus
    
    var body: some View {
        VStack {
            HStack {
                Image(systemName: channelin.icon())
                    .scaledToFit()
                    .frame(width: 10, height: 10)
                Text("→")
                    .font(.system(size: 10))
                    .fontWeight(.light)
                Image(systemName: channelout.icon())
                    .scaledToFit()
                    .frame(width: 10, height: 10)
            }
            Toggle("", isOn: $state)
                .toggleStyle(CheckboxStyle())
                .scaleEffect(0.7)
                .onChange(of: state) { newValue in
                    _ = mixer.selectedDevice.SetRouter(inputDevice: channelin, outputDevice: channelout, state: newValue)
                }
        }.padding(.horizontal, 9)
    }
}
