//
//  CoughView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 15/08/2022.
//

import Foundation
import AVFAudio
import AVFoundation
import SwiftUI

struct CoughView: View {
    @EnvironmentObject var mixer: MixerStatus

    @State private var testSelection = "1"
    @State private var testSelection2 = "1"

    
    var body: some View {
        Text("Cough button")
            .font(.system(.title2))
            .padding(.top, 20)
            .padding(.right, 160)
            .padding(.bottom, 12)
        VStack(alignment: .center) {
            Form {
                Section(header: Text("Behaviour")) {
                    
                    Picker("", selection: $mixer.coughBehaviourIsHold) {
                        Text("Hold").tag(true)
                        Text("Toggle").tag(false)
                    }.pickerStyle(.segmented)
                        .padding(.bottom, 40)
                        .onChange(of: mixer.coughBehaviourIsHold) { newValue in
                            mixer.selectedDevice.SetCoughIsHold(state: newValue)
                        }
                }
                Section(header: Text("Mute option")) {
                    Picker("", selection: $mixer.coughMuteBehaviour) {
                        Text("Mute to All").tag(MuteFunction.All)
                        Text("Mute to Stream").tag(MuteFunction.ToStream)
                        Text("Mute to Chat").tag(MuteFunction.ToVoiceChat)
                        Text("Mute to Phones").tag(MuteFunction.ToPhones)
                        Text("Mute to Line-out").tag(MuteFunction.ToLineOut)
                    }.pickerStyle(.automatic)
                        .onChange(of: mixer.coughMuteBehaviour) { newValue in
                            mixer.selectedDevice.SetCoughMuteFunction(MuteFunction: newValue)
                        }
                }
            }.padding(30)
        }.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") {
                    mixer.updateMixerStatus()
                    mixer.updateFaderDetails()
                    mixer.coughSheet = false
                }
            }
        }
        .frame(width: 300, height: 200)
        .navigationTitle("test")
        .onAppear() {
            mixer.updateFaderDetails()
        }
    }
}
