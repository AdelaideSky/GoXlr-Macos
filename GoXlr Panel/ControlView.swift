//
//  ControlView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//


extension String {
    func index(from: Int) -> Index {
        return self.index(startIndex, offsetBy: from)
    }
    

    func substring(from: Int) -> String {
        let fromIndex = index(from: from)
        return String(self[fromIndex...])
    }

    func substring(to: Int) -> String {
        let toIndex = index(from: to)
        return String(self[..<toIndex])
    }

    func substring(with r: Range<Int>) -> String {
        let startIndex = index(from: r.lowerBound)
        let endIndex = index(from: r.upperBound)
        return String(self[startIndex..<endIndex])
    }
}

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

import SwiftUI
import ShellOut
import UniformTypeIdentifiers

struct ControlView: View {
    @State private var mic: Double = 0
    @State private var chat: Double = 0
    @State private var music: Double = 0
    @State private var game: Double = 0
    @State private var console: Double = 0
    @State private var linein: Double = 0
    @State private var lineout: Double = 0
    @State private var system: Double = 0
    @State private var sample: Double = 0
    @State private var bleep: Double = 0
    @State private var headphones: Double = 0
    @State private var micmonitor: Double = 0
    @State var showFileChooser = false
    @State var tabname: String? = "Mixer"

    let profiletype = UTType(filenameExtension: "goxlr")
    @State private var showingAlert = false
    let usrPath = FileManager.default.homeDirectoryForCurrentUser

    @State private var selectedSliderA: String = "/"
    @State private var selectedSliderB: String = "/"
    @State private var selectedSliderC: String = "/"
    @State private var selectedSliderD: String = "/"
    @State private var alertMessage = "Unspecified error"
    func SelectsUpdate() {
        let state = GetGoXlrState()
        if state[0] != "nil" {
            selectedSliderA = String(state[3])
            selectedSliderB = String(state[4])
            selectedSliderC = String(state[5])
            selectedSliderD = String(state[6])
            if state[3] == "linein" {
                selectedSliderA = "line-in"
            }
            if state[4] == "linein" {
                selectedSliderB = "line-in"
            }
            if state[5] == "linein" {
                selectedSliderC = "line-in"
            }
            if state[6] == "linein" {
                selectedSliderD = "line-in"
            }
            if state[3] == "lineout" {
                selectedSliderA = "line-out"
            }
            if state[4] == "lineout" {
                selectedSliderB = "line-out"
            }
            if state[5] == "lineout" {
                selectedSliderC = "line-out"
            }
            if state[6] == "lineout" {
                selectedSliderD = "line-out"
            }
        }
    }
    func InitialUpdate() {
        let state = GetGoXlrState()
        if state[0] != "nil" {
            selectedSliderA = String(state[3])
            selectedSliderB = String(state[4])
            selectedSliderC = String(state[5])
            selectedSliderD = String(state[6])
            var volume = 0
            volume = (Int(state[7]) ?? 0) * 255 / 100
            mic = Double(volume)
            volume = (Int(state[8]) ?? 0) * 255 / 100
            chat = Double(volume)
            volume = (Int(state[9]) ?? 0) * 255 / 100
            music = Double(volume)
            volume = (Int(state[10]) ?? 0) * 255 / 100
            game = Double(volume)
            volume = (Int(state[11]) ?? 0) * 255 / 100
            console = Double(volume)
            volume = (Int(state[12]) ?? 0) * 255 / 100
            linein = Double(volume)
            volume = (Int(state[13]) ?? 0) * 255 / 100
            lineout = Double(volume)
            volume = (Int(state[14]) ?? 0) * 255 / 100
            system = Double(volume)
            volume = (Int(state[15]) ?? 0) * 255 / 100
            sample = Double(volume)
            volume = (Int(state[16]) ?? 0) * 255 / 100
            headphones = Double(volume)
            volume = (Int(state[17]) ?? 0) * 255 / 100
            micmonitor = Double(volume)
        }
    }
    
    var body: some View {
        
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(alignment: .top, spacing: 10){
                        VStack(){
                            Slider(value: $mic, in: 0...255){ newProgress in
                                
                                let roundedvalue = String(format: "%.0f", mic)
                                print(ClientCommand(arg1: "--mic-volume", arg2:  roundedvalue))
                                    
                            }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Mic")
                        }
                        VStack(){
                            Slider(value: $chat, in: 0...255){ newProgress in
                                
                                let roundedvalue = String(format: "%.0f", chat)
                                print(ClientCommand(arg1: "--chat-volume", arg2:  roundedvalue))
                            }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Chat")
                        }
                        VStack(){
                        Slider(value: $music, in: 0...255){ newProgress in
                            let roundedvalue = String(format: "%.0f", music)
                            print(ClientCommand(arg1: "--music-volume", arg2:  roundedvalue))
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                            
                        Text("Music")
                        }
                        VStack(){
                        Slider(value: $game, in: 0...255){ newProgress in
                            let roundedvalue = String(format: "%.0f", game)
                            print(ClientCommand(arg1: "--game-volume", arg2:  roundedvalue))
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Game")
                        }
                        VStack(){
                        Slider(value: $console, in: 0...255){ newProgress in
                            let roundedvalue = String(format: "%.0f", console)
                            print(ClientCommand(arg1: "--console-volume", arg2:  roundedvalue))
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Console")
                        }
                        VStack(){
                        
                        Slider(value: $linein, in: 0...255){ newProgress in
                            let roundedvalue = String(format: "%.0f", linein)
                            print(ClientCommand(arg1: "--line-in-volume", arg2:  roundedvalue))
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Line-In")
                            
                        }
                        VStack(){
                        
                        Slider(value: $lineout, in: 0...255){ newProgress in
                            let roundedvalue = String(format: "%.0f", lineout)
                            print(ClientCommand(arg1: "--line-out-volume", arg2:  roundedvalue))
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Line-Out")
                            
                        }
                        VStack(){
                            Slider(value: $system, in: 0...255){ newProgress in
                                let roundedvalue = String(format: "%.0f", system)
                                print(ClientCommand(arg1: "--system-volume", arg2:  roundedvalue))
                            }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("System")
                        }
                        VStack(){
                            Slider(value: $sample, in: 0...255){ newProgress in
                                let roundedvalue = String(format: "%.0f", sample)
                                print(ClientCommand(arg1: "--sample-volume", arg2:  roundedvalue))
                            }.rotationEffect(.degrees(-90.0), anchor: .center)
                                .padding(.bottom, 50)
                                .frame(width: 100.0)
                        Text("Sample")
                        }.padding(.right, 60)
                        
                Group() {
                    VStack(){
                        Slider(value: $headphones, in: 0...255){ newProgress in
                            let roundedvalue = String(format: "%.0f", headphones)
                            print(ClientCommand(arg1: "--headphones-volume", arg2:  roundedvalue))
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                            .padding(.bottom, 50)
                            .frame(width: 100.0)
                    Text("Headphones")
                    }
                    VStack(){
                        Slider(value: $micmonitor, in: 0...255){ newProgress in
                            let roundedvalue = String(format: "%.0f", micmonitor)
                                print(ClientCommand(arg1: "--mic-monitor-volume", arg2:  roundedvalue))
                        }.rotationEffect(.degrees(-90.0), anchor: .center)
                            .padding(.bottom, 50)
                            .frame(width: 100.0)
                    Text("Mic Monitor")
                    }
                }
                
                    }
                    .padding(.top, 40)
                    .onAppear(perform: InitialUpdate)
        }
        
        HStack(alignment: .top, spacing: 10){
            VStack(){
                Picker("", selection: $selectedSliderA) {
                    Group {
                    Text("System").tag("system")
                    Text("Music").tag("music")
                    Text("Game").tag("game")
                    Text("Chat").tag("chat")
                    Text("Line-In").tag("line-in")
                    }
                    Group {
                    Text("Mic").tag("mic")
                    Text("Console").tag("console")
                    Text("Sample").tag("sample")
                    Text("Headphones").tag("headphones")
                    Text("Mic monitor").tag("mic-monitor")
                    Text("Line Out").tag("line-out")
                    }
                }.onChange(of: self.selectedSliderA, perform: { newValue in
                        print(ClientCommand(arg1: "--fader-a", arg2:  self.selectedSliderA))
                        SelectsUpdate()
                })
            Text("Fader A")
            }
            VStack(){
                Picker("", selection: $selectedSliderB) {
                    Group {
                    Text("System").tag("system")
                    Text("Music").tag("music")
                    Text("Game").tag("game")
                    Text("Chat").tag("chat")
                    Text("Line-In").tag("line-in")
                    }
                    Group {
                    Text("Mic").tag("mic")
                    Text("Console").tag("console")
                    Text("Sample").tag("sample")
                    Text("Headphones").tag("headphones")
                    Text("Mic monitor").tag("mic-monitor")
                    Text("Line Out").tag("line-out")
                    }

                }.onChange(of: self.selectedSliderB, perform: { newValue in
                    print(ClientCommand(arg1: "--fader-b", arg2:  self.selectedSliderB))
                    SelectsUpdate()
            })
            Text("Fader B")
            }
            VStack(){
                Picker("", selection: $selectedSliderC) {
                    Group {
                    Text("System").tag("system")
                    Text("Music").tag("music")
                    Text("Game").tag("game")
                    Text("Chat").tag("chat")
                    Text("Line-In").tag("line-in")
                    }
                    Group {
                    Text("Mic").tag("mic")
                    Text("Console").tag("console")
                    Text("Sample").tag("sample")
                    Text("Headphones").tag("headphones")
                    Text("Mic monitor").tag("mic-monitor")
                    Text("Line Out").tag("line-out")
                    }
                }.onChange(of: self.selectedSliderC, perform: { newValue in
                    print(ClientCommand(arg1: "--fader-c", arg2:  self.selectedSliderC))
                    SelectsUpdate()
            })
            Text("Fader C")
            }
            VStack(){
                Picker("", selection: $selectedSliderD) {
                    Group {
                    Text("System").tag("system")
                    Text("Music").tag("music")
                    Text("Game").tag("game")
                    Text("Chat").tag("chat")
                    Text("Line-In").tag("line-in")
                    }
                    Group {
                    Text("Mic").tag("mic")
                    Text("Console").tag("console")
                    Text("Sample").tag("sample")
                    Text("Headphones").tag("headphones")
                    Text("Mic monitor").tag("mic-monitor")
                    Text("Line Out").tag("line-out")
                    }
                }.onChange(of: self.selectedSliderD, perform: { newValue in
                    print(ClientCommand(arg1: "--fader-d", arg2:  self.selectedSliderD))
                    SelectsUpdate()
            })
            Text("Fader D")
            }
        }
        .padding(.top, 90)
        .padding(.bottom, 20)
        .padding(.left, 90)
        .padding(.right, 90)
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
                    LoadProfile(url: strfileUrl)
                    
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
                    Button(action: {SaveProfile()}, label: {
                        Text("Save Profile")
                    })
                }
            }
    }
}
