//
//  RoutingView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//

import SwiftUI
import ShellOut
import UniformTypeIdentifiers
struct CheckboxStyle: ToggleStyle {
 
    func makeBody(configuration: Self.Configuration) -> some View {
 
        return HStack {
   
            Image(systemName: configuration.isOn ? "checkmark.circle.fill" : "circle")
                .resizable()
                .frame(width: 24, height: 24)
                .foregroundColor(configuration.isOn ? .purple : .gray)
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
    @State var showFileChooser = false
    @State var toggle = false
    
    
    @State var micstream = false
    @State var micchat = false
    @State var michead = false
    @State var micline = false
    @State var micsampl = false
    @State var chatstream = false
    @State var chathead = false
    @State var chatline = false
    @State var chatsampl = false
    @State var musicstream = false
    @State var musicchat = false
    @State var musichead = false
    @State var musicline = false
    @State var musicsampl = false
    @State var gamestream = false
    @State var gamechat = false
    @State var gamehead = false
    @State var gameline = false
    @State var gamesampl = false
    @State var consolestream = false
    @State var consolechat = false
    @State var consolehead = false
    @State var consoleline = false
    @State var consolesampl = false
    @State var lineinstream = false
    @State var lineinchat = false
    @State var lineinhead = false
    @State var lineinline = false
    @State var lineinsampl = false
    @State var systemstream = false
    @State var systemchat = false
    @State var systemhead = false
    @State var systemline = false
    @State var systemsampl = false
    @State var samplstream = false
    @State var samplchat = false
    @State var samplhead = false
    @State var samplline = false
    let profiletype = UTType(filenameExtension: "goxlr")

    func RoutingInit() {
        let data = GetGoXlrState()
        micstream = cBool(i: data[18])
        micchat = cBool(i: data[19])
        michead = cBool(i: data[20])
        micline = cBool(i: data[21])
        micsampl = cBool(i: data[22])
        chatstream = cBool(i: data[23])
        chathead = cBool(i: data[24])
        chatline = cBool(i: data[25])
        chatsampl = cBool(i: data[26])
        musicstream = cBool(i: data[27])
        musicchat = cBool(i: data[28])
        musichead = cBool(i: data[29])
        musicline = cBool(i: data[30])
        musicsampl = cBool(i: data[31])
        gamestream = cBool(i: data[32])
        gamechat = cBool(i: data[33])
        gamehead = cBool(i: data[34])
        gameline = cBool(i: data[35])
        gamesampl = cBool(i: data[36])
        consolestream = cBool(i: data[37])
        consolechat = cBool(i: data[38])
        consolehead = cBool(i: data[39])
        consoleline = cBool(i: data[40])
        consolesampl = cBool(i: data[41])
        lineinstream = cBool(i: data[42])
        lineinchat = cBool(i: data[43])
        lineinhead = cBool(i: data[44])
        lineinline = cBool(i: data[45])
        lineinsampl = cBool(i: data[46])
        systemstream = cBool(i: data[47])
        systemchat = cBool(i: data[48])
        systemhead = cBool(i: data[49])
        systemline = cBool(i: data[50])
        systemsampl = cBool(i: data[51])
        samplstream = cBool(i: data[52])
        samplchat = cBool(i: data[53])
        samplhead = cBool(i: data[54])
        samplline = cBool(i: data[55])
    }
    var body: some View {
        
        ScrollView(showsIndicators: false) {
            VStack(alignment: .center) {
                HStack {
                    VStack(alignment: .center) {
                        Text("Stream")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.top, 90)
                            .padding(.bottom, 35)
                        Text("Chat")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.bottom, 35)
                        Text("Headphones")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.bottom, 65)
                        Text("Line-Out")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.bottom, 35)
                        Text("Samples")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding(.bottom, 35)
                    }.padding()
                    VStack(alignment: .center) {
                        Text("Mic")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("micstream", isOn: $micstream)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: micstream) { value in
                                        ToggleRouting(chanin: "microphone", chanout: "broadcast-mix", state: value)
                                    }
                        Toggle("micchat", isOn: $micchat)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: micchat) { value in
                                        ToggleRouting(chanin: "microphone", chanout: "chat-mic", state: value)
                                    }
                        Toggle("michead", isOn: $michead)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        .onChange(of: michead) { value in
                                        ToggleRouting(chanin: "microphone", chanout: "headphones", state: value)
                                    }
                        Toggle("micline", isOn: $micline)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: micline) { value in
                                        ToggleRouting(chanin: "microphone", chanout: "line-out", state: value)
                                    }
                        Toggle("micsampl", isOn: $micsampl)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: micsampl) { value in
                                        ToggleRouting(chanin: "microphone", chanout: "sampler", state: value)
                                    }
                    }
                    VStack(alignment: .center) {
                        Text("Chat")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("chatstream", isOn: $chatstream)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: chatstream) { value in
                                        ToggleRouting(chanin: "chat", chanout: "broadcast-mix", state: value)
                                    }
                        Toggle("chatchat", isOn: $toggle)
                        .padding(15)
                        .toggleStyle(NotPossibleStyle())
                        Toggle("chathead", isOn: $chathead)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        .onChange(of: chathead) { value in
                                        ToggleRouting(chanin: "chat", chanout: "headphones", state: value)
                                    }
                        Toggle("chatline", isOn: $chatline)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: chatline) { value in
                                        ToggleRouting(chanin: "chat", chanout: "line-out", state: value)
                                    }
                        Toggle("chatsampl", isOn: $chatsampl)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: chatsampl) { value in
                                        ToggleRouting(chanin: "chat", chanout: "sampler", state: value)
                                    }
                    }
                    VStack(alignment: .center) {
                        Text("Music")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("musicstream", isOn: $musicstream)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: musicstream) { value in
                                        ToggleRouting(chanin: "music", chanout: "broadcast-mix", state: value)
                                    }
                        Toggle("musicchat", isOn: $musicchat)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: musicchat) { value in
                                        ToggleRouting(chanin: "music", chanout: "chat-mic", state: value)
                                    }
                        Toggle("musichead", isOn: $musichead)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        .onChange(of: musichead) { value in
                                        ToggleRouting(chanin: "music", chanout: "headphones", state: value)
                                    }
                        Toggle("musicline", isOn: $musicline)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: musicline) { value in
                                        ToggleRouting(chanin: "music", chanout: "line-out", state: value)
                                    }
                        Toggle("musicsampl", isOn: $musicsampl)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: musicsampl) { value in
                                        ToggleRouting(chanin: "music", chanout: "sampler", state: value)
                                    }
                    }
                    VStack(alignment: .center) {
                        Text("Game")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("gamestream", isOn: $gamestream)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: gamestream) { value in
                                        ToggleRouting(chanin: "game", chanout: "broadcast-mix", state: value)
                                    }
                        Toggle("gamechat", isOn: $gamechat)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: gamechat) { value in
                                        ToggleRouting(chanin: "game", chanout: "chat-mic", state: value)
                                    }
                        Toggle("gamehead", isOn: $gamehead)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        .onChange(of: gamehead) { value in
                                        ToggleRouting(chanin: "game", chanout: "headphones", state: value)
                                    }
                        Toggle("gameline", isOn: $gameline)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: gameline) { value in
                                        ToggleRouting(chanin: "game", chanout: "line-out", state: value)
                                    }
                        Toggle("gamesampl", isOn: $gamesampl)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: gamesampl) { value in
                                        ToggleRouting(chanin: "game", chanout: "sampler", state: value)
                                    }
                    }
                    VStack(alignment: .center) {
                        Text("Console")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("consolestream", isOn: $consolestream)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: consolestream) { value in
                                        ToggleRouting(chanin: "console", chanout: "broadcast-mix", state: value)
                                    }
                        Toggle("consolechat", isOn: $consolechat)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: consolechat) { value in
                                        ToggleRouting(chanin: "console", chanout: "chat-mic", state: value)
                                    }
                        Toggle("consolehead", isOn: $consolehead)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        .onChange(of: consolehead) { value in
                                        ToggleRouting(chanin: "console", chanout: "headphones", state: value)
                                    }
                        Toggle("consoleline", isOn: $consoleline)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: consoleline) { value in
                                        ToggleRouting(chanin: "console", chanout: "line-out", state: value)
                                    }
                        Toggle("consolesampl", isOn: $consolesampl)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: consolesampl) { value in
                                        ToggleRouting(chanin: "console", chanout: "sampler", state: value)
                                    }
                    }
                    VStack(alignment: .center) {
                        Text("Line-In")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("lineinstream", isOn: $lineinstream)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: lineinstream) { value in
                                        ToggleRouting(chanin: "line-in", chanout: "broadcast-mix", state: value)
                                    }
                        Toggle("lineinchat", isOn: $lineinchat)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: lineinchat) { value in
                                        ToggleRouting(chanin: "line-in", chanout: "chat-mic", state: value)
                                    }
                        Toggle("lineinhead", isOn: $lineinhead)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        .onChange(of: lineinhead) { value in
                                        ToggleRouting(chanin: "line-in", chanout: "headphones", state: value)
                                    }
                        Toggle("lineinline", isOn: $lineinline)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: lineinline) { value in
                                        ToggleRouting(chanin: "line-in", chanout: "line-out", state: value)
                                    }
                        Toggle("lineinsampl", isOn: $lineinsampl)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: lineinsampl) { value in
                                        ToggleRouting(chanin: "line-in", chanout: "sampler", state: value)
                                    }
                    }
                    VStack(alignment: .center) {
                        Text("System")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("systemstream", isOn: $systemstream)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: systemstream) { value in
                                        ToggleRouting(chanin: "system", chanout: "broadcast-mix", state: value)
                                    }
                        Toggle("systemchat", isOn: $systemchat)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: systemchat) { value in
                                        ToggleRouting(chanin: "system", chanout: "chat-mic", state: value)
                                    }
                        Toggle("systemhead", isOn: $systemhead)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        .onChange(of: systemhead) { value in
                                        ToggleRouting(chanin: "system", chanout: "headphones", state: value)
                                    }
                        Toggle("systemline", isOn: $systemline)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: systemline) { value in
                                        ToggleRouting(chanin: "system", chanout: "line-out", state: value)
                                    }
                        Toggle("systemsampl", isOn: $systemsampl)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: systemsampl) { value in
                                        ToggleRouting(chanin: "system", chanout: "sampler", state: value)
                                    }
                    }
                    VStack(alignment: .center) {
                        Text("Samples")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("samplstream", isOn: $samplstream)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: samplstream) { value in
                                        ToggleRouting(chanin: "samples", chanout: "broadcast-mix", state: value)
                                    }
                        Toggle("samplchat", isOn: $samplchat)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: samplchat) { value in
                                        ToggleRouting(chanin: "samples", chanout: "chat-mic", state: value)
                                    }
                        Toggle("samplhead", isOn: $samplhead)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        .onChange(of: samplhead) { value in
                                        ToggleRouting(chanin: "samples", chanout: "headphones", state: value)
                                    }
                        Toggle("samplline", isOn: $samplline)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .onChange(of: samplline) { value in
                                        ToggleRouting(chanin: "samples", chanout: "line-out", state: value)
                                    }
                        Toggle("samplsampl", isOn: $toggle)
                        .padding(15)
                        .toggleStyle(NotPossibleStyle())
                    }
                }
            }
        }.navigationTitle(tabname!)
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
            .onAppear(perform: RoutingInit)
    }
}
