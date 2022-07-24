//
//  MicSetupView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 22/07/2022.
//

import Foundation
import AVFAudio
import AVFoundation
import SwiftUI

struct MicSetupView: View {
    @EnvironmentObject var mixer: MixerStatus
    @State private var timer: Timer?
    
    
    func startGainUpdate() {
        let captureSession = goXlrCaptureSession()
        captureSession.startRunning()
        timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { (timer) in
            let tmplevel = (captureSession.outputs.first?.connections.first?.audioChannels[22].averagePowerLevel)! + 5
            if tmplevel > -40 {
                mixer.micLevel = tmplevel
            }
            else {
                mixer.micLevel = -40
            }
                })
    }
    var body: some View {
        VStack(alignment: .center) {
            NavigationView {
                List {
                    
                    Text("Mic Type")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    Group{
                        NavigationLink(destination: msDynamicView().environmentObject(mixer)) {
                            Text("Dynamic")
                        }
                        NavigationLink(destination: msCondenserView().environmentObject(mixer)) {
                            Text("Condenser")
                        }
                        NavigationLink(destination: msJackView().environmentObject(mixer)) {
                            Text("3.5 mm")
                        }
                    }
                    
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 150, idealWidth: 250, maxWidth: 300)
                .onAppear(perform: { startGainUpdate() })
                .onDisappear(perform: { timer?.invalidate() })
                
                msDynamicView().environmentObject(mixer)
            }
        }.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Done") {
                    mixer.micSetup = false

                }
            }
        }
        .frame(width: 600, height: 350)
    }
}


struct msDynamicView: View {
    @EnvironmentObject var mixer: MixerStatus
    
    
    
    var body: some View {
        Text("Dynamic").font(.system(.title)).padding(.top).padding(.right, 330)
        HStack {
            VStack {
                Text("Gain")
                    .font(.system(.body))
                    .padding(.top, 10)
                
                lightBSLIDER(value: $mixer.dynamicGain, in: 0...72, display: "", textsize: 11).padding(.top, 10)
                    .onChange(of: mixer.dynamicGain) { newValue in
                        mixer.selectedDevice.SetMicrophoneGain(microphoneType: .Dynamic, gain: Int(newValue))
                    }
                Text("\(Int(mixer.dynamicGain)) dB")
                    .font(.system(.body))
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                    .padding(.top, 5)
            }
            VStack(alignment: .center) {
                Text("Mic monitor")
                    .font(.system(.body))
                    .padding(.top, 10)
                    .padding(.right, 20)
                micMonitor(value: $mixer.micLevel, in: -40...0, display: "", textsize: 11)
                    .padding(15)
                    .padding(.left, 70)
                    .padding(.right, 80)

                
            }
        }.padding(20)
    }
}

struct msCondenserView: View {
    @EnvironmentObject var mixer: MixerStatus
    
    var body: some View {
        Text("Condenser").font(.system(.title)).padding(.top).padding(.right, 320)
        HStack {
            VStack {
                Text("Gain")
                    .font(.system(.body))
                    .padding(.top, 10)
                
                lightBSLIDER(value: $mixer.condenserGain, in: 0...72, display: "", textsize: 11).padding(.top, 10)
                    .onChange(of: mixer.condenserGain) { newValue in
                        mixer.selectedDevice.SetMicrophoneGain(microphoneType: .Condenser, gain: Int(newValue))
                    }
                Text("\(Int(mixer.condenserGain)) dB")
                    .font(.system(.body))
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                    .padding(.top, 5)
            }
            VStack(alignment: .center) {
                Text("Mic monitor")
                    .font(.system(.body))
                    .padding(.top, 10)
                    .padding(.right, 20)
                micMonitor(value: $mixer.micLevel, in: -40...0, display: "", textsize: 11).padding(15)
                    .padding(.left, 70)
                    .padding(.right, 80)

            }
        }.padding(20)
    }
}


struct msJackView: View {
    @EnvironmentObject var mixer: MixerStatus
    
    var body: some View {
        Text("3.5 mm").font(.system(.title)).padding(.top).padding(.right, 350)
        HStack {
            VStack {
                Text("Gain")
                    .font(.system(.body))
                    .padding(.top, 10)
                
                lightBSLIDER(value: $mixer.jackGain, in: 0...72, display: "", textsize: 11).padding(.top, 10)
                    .onChange(of: mixer.jackGain) { newValue in
                        mixer.selectedDevice.SetMicrophoneGain(microphoneType: .Jack, gain: Int(newValue))
                    }
                Text("\(Int(mixer.jackGain)) dB")
                    .font(.system(.body))
                    .foregroundColor(.gray)
                    .padding(.bottom, 10)
                    .padding(.top, 5)
            }
            VStack(alignment: .center) {
                Text("Mic monitor")
                    .font(.system(.body))
                    .padding(.top, 10)
                    .padding(.right, 20)
                micMonitor(value: $mixer.micLevel, in: -40...0, display: "", textsize: 11).padding(15)
                    .padding(.left, 70)
                    .padding(.right, 80)

            }
        }.padding(20)
    }
}
