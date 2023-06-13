//
//  MixerSettingsPage.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 23/04/2023.
//

import SwiftUI
import GoXlrKit

struct MixerSettingsPage: View {
    
    @ObservedObject var mixer: Mixer
    var device: String
    var model: GoXlrModel
    
    init(_ device: String, model: GoXlrModel) {
        self.device = device
        self.mixer = GoXlr.shared.status!.data.status.mixers[device]!
        self.model = model
    }
    
    var body: some View {
        Form {
            Section("Device Settings") {
                TextField("Mute Button hold to mute All duration", value: $mixer.settings.muteHoldDuration, formatter: NumberFormatter())
                Toggle("Voice Chat Mute All mutes also Mic to Chat Mic", isOn: $mixer.settings.vcMuteAlsoMuteCM)
                if model == .Full {
                    HStack {
                        VStack(alignment: .leading) {
                            Text("Sampler pre-record buffer")
                            Text("Requires daemon restart")
                                .font(.caption)
                        }
                        Spacer()
                        TextField("", value: $mixer.sampler.unwrap()!.recordBuffer, formatter: NumberFormatter())
                    }
                }
            }
            Section("Firmware Update") {
                HStack {
                    Spacer()
                    VStack {
                        Text(mixer.hardware.versions.firmware.compactMap({ "\($0)" }).joined(separator: "."))
                            .textSelection(.enabled)
                        Text("Last checked: None")
                        Text("Firmware updates are not supported yet.")
                    }.opacity(0.7)
                        .padding()
                    Spacer()
                }
                
            }
            Section("About your device") {
                HStack {
                    Text("Model type")
                    Spacer()
                    Text(mixer.hardware.deviceType.rawValue)
                        .textSelection(.enabled)
                }
                HStack {
                    Text("Manufactured date")
                    Spacer()
                    Text(mixer.hardware.manufacturedDate)
                        .textSelection(.enabled)
                }
                HStack {
                    Text("Dice")
                    Spacer()
                    Text(mixer.hardware.versions.dice.compactMap({ "\($0)" }).joined(separator: "."))
                        .textSelection(.enabled)
                }
                HStack {
                    Text("FPGA")
                    Spacer()
                    Text("\(mixer.hardware.versions.fpgaCount)")
                        .textSelection(.enabled)
                }
                HStack {
                    Text("Serial number")
                    Spacer()
                    Text(mixer.hardware.serialNumber)
                        .textSelection(.enabled)
                }
            }
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
    }
}
