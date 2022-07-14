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
    

    let timer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
        
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
                    Text("Mic")}
                VStack(){
                    Slider(value: $mixer.chat, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Chat")}
                
                VStack(){
                    Slider(value: $mixer.music, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Music")}
                VStack(){
                    Slider(value: $mixer.game, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Game")}
                VStack(){
                    Slider(value: $mixer.console, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Console")}
                VStack(){
                    Slider(value: $mixer.linein, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Line-In")}
                VStack(){
                    Slider(value: $mixer.lineout, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Line-Out")}
                VStack(){
                    Slider(value: $mixer.system, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("System")}
                VStack(){
                    Slider(value: $mixer.sample, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                        .padding(.bottom, 50)
                        .frame(width: 100.0)
                        .animation(.easeInOut, value: 4)
                    Text("Sample")}.padding(.right, 60)
                
                Group() {
                    VStack(){
                        Slider(value: $mixer.headphones, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                            .padding(.bottom, 50)
                            .frame(width: 100.0)
                            .animation(.easeInOut, value: 4)
                        Text("Headphones")}
                    VStack(){
                        Slider(value: $mixer.micmonitor, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                            .padding(.bottom, 50)
                            .frame(width: 100.0)
                            .animation(.easeInOut, value: 4)
                        Text("Mic-Monitor")}
                    VStack(){
                        Slider(value: $mixer.bleep, in: 0...255){ }.rotationEffect(.degrees(-90.0), anchor: .center)
                            .padding(.bottom, 50)
                            .frame(width: 100.0)
                            .animation(.easeInOut, value: 4)
                        Text("Bleep")}
                }
                
            }.padding(.top, 40)
        }
        
        HStack(alignment: .top, spacing: 10) {
            VStack() {
                Text("Fader A")
                Picker("", selection: $mixer.sliderA) {
                    ForEach(ChannelName.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}.padding()
                    
                Text("Mute")
                Picker("", selection: $mixer.muteA) {
                    ForEach(MuteFunction.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}
            }.padding()
                .background(graycolor)
            VStack() {
                Text("Fader B")
                Picker("", selection: $mixer.sliderB) {
                    ForEach(ChannelName.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}.padding()
                Text("Mute")
                Picker("", selection: $mixer.muteB) {
                    ForEach(MuteFunction.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}
            }.padding()
                .background(graycolor)
            VStack() {
                Text("Fader C")
                Picker("", selection: $mixer.sliderC) {
                    ForEach(ChannelName.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}.padding()
                Text("Mute")
                Picker("", selection: $mixer.muteC) {
                    ForEach(MuteFunction.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}
            }.padding()
                .background(graycolor)
            VStack() {
                Text("Fader D")
                Picker("", selection: $mixer.sliderD) {
                    ForEach(ChannelName.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}.padding()
                Text("Mute")
                Picker("", selection: $mixer.muteD) {
                    ForEach(MuteFunction.allCases, id: \.self) { value in
                        Text(value.rawValue).tag(value)}}
            }.padding()
                .background(graycolor)
        }
        .padding(.top, 70)
        .padding(.bottom, 10)
        .padding(.left, 70)
        .padding(.right, 70)
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
