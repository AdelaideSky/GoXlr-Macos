//
//  MixerView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 03/07/2022.
//

import Foundation
import SwiftUI
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
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 10){
                VStack(){
                    Slider(value: $mixer.mic, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Mic")}.onChange(of: mixer.mic) { newValue in
                        mixer.selectedDevice.SetVolume(channel: .Mic, volume: Int(newValue))
                    }
                VStack(){
                    Slider(value: $mixer.chat, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Chat")}.onChange(of: mixer.chat) { newValue in
                        mixer.selectedDevice.SetVolume(channel: .Chat, volume: Int(newValue))
                    }
                
                VStack(){
                    Slider(value: $mixer.music, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Music")}.onChange(of: mixer.music) { newValue in
                        mixer.selectedDevice.SetVolume(channel: .Music, volume: Int(newValue))
                    }
                VStack(){
                    Slider(value: $mixer.game, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Game")}.onChange(of: mixer.game) { newValue in
                        mixer.selectedDevice.SetVolume(channel: .Game, volume: Int(newValue))
                    }
                VStack(){
                    Slider(value: $mixer.console, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Console")}.onChange(of: mixer.console) { newValue in
                        mixer.selectedDevice.SetVolume(channel: .Console, volume: Int(newValue))
                    }
                VStack(){
                    Slider(value: $mixer.linein, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Line-In")}.onChange(of: mixer.linein) { newValue in
                        mixer.selectedDevice.SetVolume(channel: .LineIn, volume: Int(newValue))
                    }
                VStack(){
                    Slider(value: $mixer.lineout, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Line-Out")}.onChange(of: mixer.lineout) { newValue in
                        mixer.selectedDevice.SetVolume(channel: .LineOut, volume: Int(newValue))
                    }
                VStack(){
                    Slider(value: $mixer.system, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("System")}.onChange(of: mixer.system) { newValue in
                        mixer.selectedDevice.SetVolume(channel: .System, volume: Int(newValue))
                    }
                VStack(){
                    Slider(value: $mixer.sample, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Sample")}.onChange(of: mixer.sample) { newValue in
                        mixer.selectedDevice.SetVolume(channel: .Sample, volume: Int(newValue))
                    }
                    .padding(.right, 60)
                
                Group() {
                    VStack(){
                        Slider(value: $mixer.headphones, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                            .padding(.bottom, 50)
                            .frame(width: 100.0)
                            .animation(.easeInOut, value: 4)
                        Text("Headphones")}.onChange(of: mixer.headphones) { newValue in
                            mixer.selectedDevice.SetVolume(channel: .Headphones, volume: Int(newValue))
                        }
                    VStack(){
                        Slider(value: $mixer.micmonitor, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                            .padding(.bottom, 50)
                            .frame(width: 100.0)
                            .animation(.easeInOut, value: 4)
                        Text("Mic-Monitor")}.onChange(of: mixer.micmonitor) { newValue in
                            mixer.selectedDevice.SetVolume(channel: .MicMonitor, volume: Int(newValue))
                        }
                    VStack(){
                        Slider(value: $mixer.bleep, in: -34...0){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                            .padding(.bottom, 50)
                            .frame(width: 100.0)
                            .animation(.easeInOut, value: 4)
                        Text("Bleep")}.onChange(of: mixer.bleep) { newValue in
                            mixer.selectedDevice.SetSwearButtonVolume(volume: Int(newValue))
                        }
                }
                
            }.padding(.top, 40)
        }
        
        HStack(alignment: .top, spacing: 10) {
            VStack() {
                Text("Fader A")
                Picker("", selection: $mixer.sliderA) {
                    ForEach(ChannelName.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}.padding()
                    .onChange(of: mixer.sliderA) { newValue in
                        mixer.selectedDevice.SetFader(fader: .A, channel: newValue)
                        mixer.updateFaderDetails()
                    }
                    
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
            }.padding()
                .background(graycolor)
            VStack() {
                Text("Fader B")
                Picker("", selection: $mixer.sliderB) {
                    ForEach(ChannelName.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}.padding()
                    .onChange(of: mixer.sliderB) { newValue in
                        mixer.selectedDevice.SetFader(fader: .B, channel: newValue)
                        mixer.updateFaderDetails()
                    }
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
            }.padding()
                .background(graycolor)
            VStack() {
                Text("Fader C")
                Picker("", selection: $mixer.sliderC) {
                    ForEach(ChannelName.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}.padding()
                    .onChange(of: mixer.sliderC) { newValue in
                        mixer.selectedDevice.SetFader(fader: .C, channel: newValue)

                        mixer.updateFaderDetails()
                    }
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
            }.padding()
                .background(graycolor)
            VStack() {
                Text("Fader D")
                Picker("", selection: $mixer.sliderD) {
                    ForEach(ChannelName.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}.padding()
                    .onChange(of: mixer.sliderD) { newValue in
                        mixer.selectedDevice.SetFader(fader: .D, channel: newValue)
                        mixer.updateFaderDetails()
                    }
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
            }.padding()
                .background(graycolor)
        }
        .padding(.top, 70)
        .padding(.bottom, 10)
        .padding(.left, 70)
        .padding(.right, 70)
        .onAppear() {
            mixer.updateMixerStatus()
        }
        .alert("ERROR", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
        } message: {
            Text("Is the daemon installed ?")
        }.navigationTitle(tabname!)
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
        .toolbar {
            ToolbarItem(placement: .automatic) {
                Button(action: {showFileChooser.toggle()}, label: {
                    Text("Load Profile")
                })
            }
            ToolbarItem(placement: .automatic) {
                Button(action: {goxlr.SaveProfile()}, label: {
                    Text("Save Profile")
                })
            }
        }
    }
}
