//
//  RoutingTab.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 31/07/2022.
//

import Foundation
import SwiftUI

extension Binding where Value == Bool {
    func negate() -> Bool {
        return !(self.wrappedValue)
    }
}

struct CheckboxStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
   
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .accentColor : .gray)
                .font(.system(size: 20, weight: .bold, design: .default))
                .onTapGesture {
                    configuration.isOn.toggle()
                }
        }
 
    }
}

struct NotPossibleStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
   
            Image(systemName: "circle.fill")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(.gray)
                .font(.system(size: 20, weight: .bold, design: .default))
        }
 
    }
}

struct RoutingView: View {
    @State var tabname: String? = "Routing"
    @State var toggle = false
    @State var showFileChooser = false
    @EnvironmentObject var mixer: MixerStatus
    var body: some View {
        ZStack() {
            VStack {
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .frame(width: 740, height: 250)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                    .padding(.bottom, 15)
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .frame(width: 740, height: 120)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
            }

            VStack {
                HStack {
                    VStack(alignment: .center) {
                        Text("Stream")
                            .font(.system(size: 14))
                            .fontWeight(.light)
                            .padding(.top, 90)
                            .padding(.bottom, 37)
                        Text("Chat")
                            .font(.system(size: 14))
                            .fontWeight(.light)
                            .padding(.bottom, 37)
                        Text("Headphones")
                            .font(.system(size: 14))
                            .fontWeight(.light)
                            .padding(.bottom, 65)
                        Text("Line-Out")
                            .font(.system(size: 14))
                            .fontWeight(.light)
                            .padding(.bottom, 37)
                        Text("Samples")
                            .font(.system(size: 14))
                            .fontWeight(.light)
                            .padding(.bottom, 37)
                    }.padding()
                    VStack(alignment: .center) {
                        Text("Mic")
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .padding()
                        Toggle("micstream", isOn: $mixer.routerMic[1])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerMic[1]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Microphone, outputDevice: .BroadcastMix, state: newValue)
                            }
                        Toggle("micchat", isOn: $mixer.routerMic[3])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerMic[3]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Microphone, outputDevice: .ChatMic, state: newValue)
                            }
                        Toggle("michead", isOn: $mixer.routerMic[0])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .padding(.bottom, 30)
                            .onChange(of: mixer.routerMic[0]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Microphone, outputDevice: .Headphones, state: newValue)
                            }
                        Toggle("micline", isOn: $mixer.routerMic[2])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerMic[2]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Microphone, outputDevice: .LineOut, state: newValue)
                            }
                        Toggle("micsampl", isOn: $mixer.routerMic[4])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerMic[4]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Microphone, outputDevice: .Sampler, state: newValue)
                            }
                    }
                    VStack(alignment: .center) {
                        Text("Chat")
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .padding()
                        Toggle("chatstream", isOn: $mixer.routerChat[1])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerChat[1]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Chat, outputDevice: .BroadcastMix, state: newValue)
                            }
                        Toggle("chatchat", isOn: $toggle)
                            .padding(15)
                            .toggleStyle(NotPossibleStyle())
                        Toggle("chathead", isOn: $mixer.routerChat[0])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .padding(.bottom, 30)
                            .onChange(of: mixer.routerChat[0]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Chat, outputDevice: .Headphones, state: newValue)
                            }
                        Toggle("chatline", isOn: $mixer.routerChat[2])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerChat[2]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Chat, outputDevice: .LineOut, state: newValue)
                            }
                        Toggle("chatsampl", isOn: $mixer.routerChat[4])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerChat[4]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Chat, outputDevice: .Sampler, state: newValue)
                            }
                    }
                    VStack(alignment: .center) {
                        Text("Music")
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .padding()
                        Toggle("musicstream", isOn: $mixer.routerMusic[1])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerMusic[1]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Music, outputDevice: .BroadcastMix, state: newValue)
                            }
                        Toggle("musicchat", isOn: $mixer.routerMusic[3])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerMusic[3]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Music, outputDevice: .ChatMic, state: newValue)
                            }
                        Toggle("musichead", isOn: $mixer.routerMusic[0])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .padding(.bottom, 30)
                            .onChange(of: mixer.routerMusic[0]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Music, outputDevice: .Headphones, state: newValue)
                            }
                        Toggle("musicline", isOn: $mixer.routerMusic[2])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerMusic[2]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Music, outputDevice: .LineOut, state: newValue)
                            }
                        Toggle("musicsampl", isOn: $mixer.routerMusic[4])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerMusic[4]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Music, outputDevice: .Sampler, state: newValue)
                            }
                    }
                    VStack(alignment: .center) {
                        Text("Game")
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .padding()
                        Toggle("gamestream", isOn: $mixer.routerGame[1])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerGame[1]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Game, outputDevice: .BroadcastMix, state: newValue)
                            }
                        Toggle("gamechat", isOn: $mixer.routerGame[3])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerGame[3]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Game, outputDevice: .ChatMic, state: newValue)
                            }
                        Toggle("gamehead", isOn: $mixer.routerGame[0])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .padding(.bottom, 30)
                            .onChange(of: mixer.routerGame[0]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Game, outputDevice: .Headphones, state: newValue)
                            }
                        Toggle("gameline", isOn: $mixer.routerGame[2])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerGame[2]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Game, outputDevice: .LineOut, state: newValue)
                            }
                        Toggle("gamesampl", isOn: $mixer.routerGame[4])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerGame[4]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Game, outputDevice: .Sampler, state: newValue)
                            }
                    }
                    VStack(alignment: .center) {
                        Text("Console")
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .padding()
                        Toggle("consolestream", isOn: $mixer.routerConsole[1])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerConsole[1]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Console, outputDevice: .BroadcastMix, state: newValue)
                            }
                        Toggle("consolechat", isOn: $mixer.routerConsole[3])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerConsole[3]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Console, outputDevice: .ChatMic, state: newValue)
                            }
                        Toggle("consolehead", isOn: $mixer.routerConsole[0])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .padding(.bottom, 30)
                            .onChange(of: mixer.routerConsole[0]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Console, outputDevice: .Headphones, state: newValue)
                            }
                        Toggle("consoleline", isOn: $mixer.routerConsole[2])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerConsole[2]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Console, outputDevice: .LineOut, state: newValue)
                            }
                        Toggle("consolesampl", isOn: $mixer.routerConsole[4])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerConsole[4]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Console, outputDevice: .Sampler, state: newValue)
                            }
                    }
                    VStack(alignment: .center) {
                        Text("Line-in")
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .padding()
                        Toggle("lineinstream", isOn: $mixer.routerLineIn[1])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerLineIn[1]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .LineIn, outputDevice: .BroadcastMix, state: newValue)
                            }
                        Toggle("lineinchat", isOn: $mixer.routerLineIn[3])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerLineIn[3]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .LineIn, outputDevice: .ChatMic, state: newValue)
                            }
                        Toggle("lineinhead", isOn: $mixer.routerLineIn[0])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .padding(.bottom, 30)
                            .onChange(of: mixer.routerLineIn[0]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .LineIn, outputDevice: .Headphones, state: newValue)
                            }
                        Toggle("lineinline", isOn: $mixer.routerLineIn[2])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerLineIn[2]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .LineIn, outputDevice: .LineOut, state: newValue)
                            }
                        Toggle("lineinsampl", isOn: $mixer.routerLineIn[4])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerLineIn[4]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .LineIn, outputDevice: .Sampler, state: newValue)
                            }
                    }
                    VStack(alignment: .center) {
                        Text("System")
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .padding()
                        Toggle("systemstream", isOn: $mixer.routerSystem[1])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerSystem[1]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .System, outputDevice: .BroadcastMix, state: newValue)
                            }
                        Toggle("systemchat", isOn: $mixer.routerSystem[3])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerSystem[3]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .System, outputDevice: .ChatMic, state: newValue)
                            }
                        Toggle("systemhead", isOn: $mixer.routerSystem[0])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .padding(.bottom, 30)
                            .onChange(of: mixer.routerSystem[0]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .System, outputDevice: .Headphones, state: newValue)
                            }
                        Toggle("systemline", isOn: $mixer.routerSystem[2])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerSystem[2]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .System, outputDevice: .LineOut, state: newValue)
                            }
                        Toggle("systemsampl", isOn: $mixer.routerSystem[4])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerSystem[4]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .System, outputDevice: .Sampler, state: newValue)
                            }
                    }
                    VStack(alignment: .center) {
                        Text("Samples")
                            .font(.system(size: 13))
                            .fontWeight(.light)
                            .padding()
                        Toggle("samplesstream", isOn: $mixer.routerSamples[1])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerSamples[1]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Samples, outputDevice: .BroadcastMix, state: newValue)
                            }
                        Toggle("sampleschat", isOn: $mixer.routerSamples[3])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerSamples[3]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Samples, outputDevice: .ChatMic, state: newValue)
                            }
                        Toggle("sampleshead", isOn: $mixer.routerSamples[0])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .padding(.bottom, 30)
                            .onChange(of: mixer.routerSamples[0]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Samples, outputDevice: .Headphones, state: newValue)
                            }
                        Toggle("samplesline", isOn: $mixer.routerSamples[2])
                            .padding(15)
                            .toggleStyle(CheckboxStyle())
                            .onChange(of: mixer.routerSamples[2]) { newValue in
                                _ = mixer.selectedDevice.SetRouter(inputDevice: .Samples, outputDevice: .LineOut, state: newValue)
                            }
                        Toggle("samplessamples", isOn: $toggle)
                            .padding(15)
                            .toggleStyle(NotPossibleStyle())
                    }
                }
            }
            
        }.navigationTitle(tabname!)
            .onAppear() {
                mixer.updateRouter()
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
