//
//  MixerView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 03/07/2022.
//

import Foundation
import SwiftUI
import AppKit
import UniformTypeIdentifiers

enum NoFlipEdge {
    case left, right
}

struct NoFlipPadding: ViewModifier {
    let edge: NoFlipEdge
    let length: CGFloat?
    @Environment(\.layoutDirection) var layoutDirection
    
    private var computedEdge: Edge.Set {
        if layoutDirection == .rightToLeft {
            return edge == .left ? .trailing : .leading
        } else {
            return edge == .left ? .leading : .trailing
        }
    }
    
    func body(content: Content) -> some View {
        content
            .padding(computedEdge, length)
    }
}

extension View {
    func padding(_ edge: NoFlipEdge, _ length: CGFloat? = nil) -> some View {
        self.modifier(NoFlipPadding(edge: edge, length: length))
    }
}

struct MixerView: View {
    
    @State var coughSheet = false
    
        
    @State var showFileChooser = false
    @State var tabname: String? = "Mixer"

    @State private var showingAlert = false
    let usrPath = FileManager.default.homeDirectoryForCurrentUser

    @State private var alertMessage = "Unspecified error"
    @EnvironmentObject var mixer: MixerStatus
    let profiletype = UTType(filenameExtension: "goxlr")

    
    let graycolor =  Color(white: 130, opacity: 0.03)
    var goxlr = GoXlr(serial: "")
    
    
    var body: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10).fill(.background)
                .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
            
            
            VStack(alignment: .leading) {
                Text("Channels")
                    .font(.system(.title2))
                    .padding(.top, 15)
                    .padding(.left, 20)

                ScrollView(.horizontal, showsIndicators: false) {
                    
                    HStack(alignment: .top){
                        Group {
                            VStack(){
                                Text("Mic").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.mic, in: 0...255, display: "mic", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.mic) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                }.onChange(of: mixer.mic) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .Mic, volume: Int(newValue))
                                    if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                    else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                            VStack(){
                                Text("Chat").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.chat, in: 0...255, display: "speaker.wave.2.bubble.left", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.chat) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)

                                }.onChange(of: mixer.chat) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .Chat, volume: Int(newValue))
                                    if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                    else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                            
                            VStack(){
                                Text("Music").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.music, in: 0...255, display: "music.note", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.music) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                            }.onChange(of: mixer.music) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .Music, volume: Int(newValue))
                                if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                        }
                        Group {
                            VStack(){
                                Text("Game").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.game, in: 0...255, display: "gamecontroller", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.game) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                }.onChange(of: mixer.game) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .Game, volume: Int(newValue))
                                    if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                    else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                            VStack(){
                                Text("Console").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.console, in: 0...255, display: "rectangle.on.rectangle", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.console) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                }.onChange(of: mixer.console) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .Console, volume: Int(newValue))
                                    if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                    else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                            VStack(){
                                Text("Line-In").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.linein, in: 0...255, display: "chevron.backward.to.line", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.linein) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                }.onChange(of: mixer.linein) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .LineIn, volume: Int(newValue))
                                    if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                    else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                            VStack(){
                                Text("Line-Out").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.lineout, in: 0...255, display: "chevron.right.to.line", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.lineout) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                }.onChange(of: mixer.lineout) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .LineOut, volume: Int(newValue))
                                    if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                    else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                        }
                        Group {
                            VStack(){
                                Text("System").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.system, in: 0...255, display: "menubar.dock.rectangle", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.system) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                }.onChange(of: mixer.system) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .System, volume: Int(newValue))
                                    if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                    else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                            VStack(){
                                Text("Sample").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.sample, in: 0...255, display: "waveform", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.sample) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                }.onChange(of: mixer.sample) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .Sample, volume: Int(newValue))
                                    if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                    else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                                .padding(.right, 60)
                        }
                        
                        Group() {
                            VStack(){
                                Text("Headphones").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.headphones, in: 0...255, display: "headphones", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.headphones) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                }.onChange(of: mixer.headphones) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .Headphones, volume: Int(newValue))
                                    if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                    else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                            VStack(){
                                Text("Mic-Monitor").font(.system(.subheadline)).padding(.bottom, 10)
                                lightBSLIDER(value: $mixer.micmonitor, in: 0...255, display: "mic.and.signal.meter", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                Text("\(Int(Double(mixer.micmonitor) / 255 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                }.onChange(of: mixer.micmonitor) { newValue in
                                    mixer.selectedDevice.SetVolume(channel: .MicMonitor, volume: Int(newValue))
                                    if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                    else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                            VStack(){
                                Text("Bleep").font(.system(.subheadline)).padding(.bottom, 10)

                                lightBSLIDER(value: $mixer.bleep, in: -34...0, display: "exclamationmark.bubble", textsize: 11)
                                    .padding(.bottom, 20)
                                    .frame(width: 80)
                                    .animation(.default, value: 4)
                                
                                Text("\(Int(Double(mixer.bleep+34) / 34 * 100))%")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                
                            }.onChange(of: mixer.bleep) { newValue in
                                    mixer.selectedDevice.SetSwearButtonVolume(volume: Int(newValue))
                                if newValue == 255 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                else if newValue == 0 {NSHapticFeedbackManager.defaultPerformer.perform(.levelChange, performanceTime: .now)}
                                }
                        }
                        
                    }
                }.padding(.top, 20)
                    .padding(.bottom, 20)
                    .animation(.default)
            }
            
            
        }.frame(width: 740, height: 300)
        HStack(alignment:.top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                
                VStack() {
                    Text("Fader A")
                        .font(.system(.title3))
                        .padding(.top, 10)
                        .padding(.right, 85)
                        .padding(.bottom, 12)
                    VStack() {
                        Picker("", selection: $mixer.sliderA) {
                            ForEach(ChannelName.allCases, id: \.self) { value in
                                Text(value.rawValue).tag(value)}}
                            .onChange(of: mixer.sliderA) { newValue in
                                mixer.selectedDevice.SetFader(fader: .A, channel: newValue)
                                mixer.updateFaderDetails()
                            }
                            .padding(.bottom, 10)
                        Text("Mute")
                        Picker("", selection: $mixer.muteA) {
                            Text("All").tag(MuteFunction.All)
                            Text("To stream").tag(MuteFunction.ToStream)
                            Text("To voice chat").tag(MuteFunction.ToVoiceChat)
                            Text("To phones").tag(MuteFunction.ToPhones)
                            Text("To line-out").tag(MuteFunction.ToLineOut)
                        }
                        .onChange(of: mixer.muteA) { newValue in
                            mixer.selectedDevice.SetFaderMuteFunction(faderName: .A, MuteFunction: newValue)
                            mixer.updateFaderDetails()
                        }
                    }.padding(.left, 13)
                        .padding(.right, 13)
                        .padding(.bottom, 10)
                }
                
            }.frame(width: 175, height: 145)
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                
                VStack() {
                    Text("Fader B")
                        .font(.system(.title3))
                        .padding(.top, 10)
                        .padding(.right, 85)
                        .padding(.bottom, 12)
                    VStack() {
                        Picker("", selection: $mixer.sliderB) {
                            ForEach(ChannelName.allCases, id: \.self) { value in
                                Text(value.rawValue).tag(value)}}
                            .onChange(of: mixer.sliderB) { newValue in
                                mixer.selectedDevice.SetFader(fader: .B, channel: newValue)
                                mixer.updateFaderDetails()
                            }
                            .padding(.bottom, 10)
                        Text("Mute")
                        Picker("", selection: $mixer.muteB) {
                            Text("All").tag(MuteFunction.All)
                            Text("To stream").tag(MuteFunction.ToStream)
                            Text("To voice chat").tag(MuteFunction.ToVoiceChat)
                            Text("To phones").tag(MuteFunction.ToPhones)
                            Text("To line-out").tag(MuteFunction.ToLineOut)
                        }
                        .onChange(of: mixer.muteB) { newValue in
                            mixer.selectedDevice.SetFaderMuteFunction(faderName: .B, MuteFunction: newValue)
                            mixer.updateFaderDetails()
                        }
                    }.padding(.left, 13)
                        .padding(.right, 13)
                        .padding(.bottom, 10)
                }
                
            }.frame(width: 175, height: 145)
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                
                VStack() {
                    Text("Fader C")
                        .font(.system(.title3))
                        .padding(.top, 10)
                        .padding(.right, 85)
                        .padding(.bottom, 12)
                    VStack() {
                        Picker("", selection: $mixer.sliderC) {
                            ForEach(ChannelName.allCases, id: \.self) { value in
                                Text(value.rawValue).tag(value)}}
                            .onChange(of: mixer.sliderC) { newValue in
                                mixer.selectedDevice.SetFader(fader: .C, channel: newValue)
                                mixer.updateFaderDetails()
                            }
                            .padding(.bottom, 10)
                        Text("Mute")
                        Picker("", selection: $mixer.muteC) {
                            Text("All").tag(MuteFunction.All)
                            Text("To stream").tag(MuteFunction.ToStream)
                            Text("To voice chat").tag(MuteFunction.ToVoiceChat)
                            Text("To phones").tag(MuteFunction.ToPhones)
                            Text("To line-out").tag(MuteFunction.ToLineOut)
                        }
                        .onChange(of: mixer.muteC) { newValue in
                            mixer.selectedDevice.SetFaderMuteFunction(faderName: .C, MuteFunction: newValue)
                            mixer.updateFaderDetails()
                        }
                    }.padding(.left, 13)
                        .padding(.right, 13)
                        .padding(.bottom, 10)
                }
                
            }.frame(width: 175, height: 145)
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                
                VStack() {
                    Text("Fader D")
                        .font(.system(.title3))
                        .padding(.top, 10)
                        .padding(.right, 85)
                        .padding(.bottom, 12)
                    VStack() {
                        Picker("", selection: $mixer.sliderD) {
                            ForEach(ChannelName.allCases, id: \.self) { value in
                                Text(value.rawValue).tag(value)}}
                            .onChange(of: mixer.sliderD) { newValue in
                                mixer.selectedDevice.SetFader(fader: .D, channel: newValue)
                                mixer.updateFaderDetails()
                            }
                            .padding(.bottom, 10)
                        Text("Mute")
                        Picker("", selection: $mixer.muteD) {
                            Text("All").tag(MuteFunction.All)
                            Text("To stream").tag(MuteFunction.ToStream)
                            Text("To voice chat").tag(MuteFunction.ToVoiceChat)
                            Text("To phones").tag(MuteFunction.ToPhones)
                            Text("To line-out").tag(MuteFunction.ToLineOut)
                        }
                        .onChange(of: mixer.muteD) { newValue in
                            mixer.selectedDevice.SetFaderMuteFunction(faderName: .D, MuteFunction: newValue)

                            mixer.updateFaderDetails()
                        }
                    }.padding(.left, 13)
                        .padding(.right, 13)
                        .padding(.bottom, 10)
                }
                
            }.frame(width: 175, height: 145)
        }
        .onAppear() {
            mixer.updateMixerStatus()
        }
        .alert("ERROR", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
        }
        .navigationTitle(tabname!)
        .fileImporter(isPresented: $showFileChooser, allowedContentTypes: [profiletype!], onCompletion: { result in
            print("Picked: \(result)")
            do{
                var fileUrl = try result.get()
                fileUrl = fileUrl.deletingPathExtension()
                let strfileUrl = fileUrl.path
                goxlr.LoadProfile(path: strfileUrl)
                            
            } catch{
                                        
                print ("error reading")
                print (error.localizedDescription)
            }
        })
        .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab: "device").environmentObject(mixer)})
        .sheet(isPresented: $mixer.coughSheet, content: {CoughView().environmentObject(mixer)})
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {mixer.profileSheet.toggle()}, label: {
                    Text("Load Profile")
                })
            }
            ToolbarItem(placement: .automatic) {
                Button(action: {goxlr.SaveProfile()}, label: {
                    Text("Save Profile")
                })
            }
            ToolbarItem(placement: .automatic) {
                Text("                         ")
            }
            
            ToolbarItem(placement: .primaryAction) {
                Button(action: {mixer.coughSheet.toggle()}, label: {
                    Text("Cough settings")
                })
            }
        }
    }
}
