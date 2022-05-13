//
//  RoutingView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//

import SwiftUI
import ShellOut
import UniformTypeIdentifiers

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
    let profiletype = UTType(filenameExtension: "goxlr")
    
    
    @ObservedObject var model = ListModel()

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
                        Toggle("micstream", isOn: self.$model.sections[0].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("micchat", isOn: self.$model.sections[1].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("michead", isOn: self.$model.sections[2].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        
                        Toggle("micline", isOn: self.$model.sections[3].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("micsampl", isOn: self.$model.sections[4].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                    }
                    VStack(alignment: .center) {
                        Text("Chat")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("chatstream", isOn: self.$model.sections[5].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("chatchat", isOn: $toggle)
                        .padding(15)
                        .toggleStyle(NotPossibleStyle())
                        Toggle("chathead", isOn: self.$model.sections[6].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        
                        Toggle("chatline", isOn: self.$model.sections[7].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("chatsampl", isOn: self.$model.sections[8].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                    }
                    VStack(alignment: .center) {
                        Text("Music")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("musicstream", isOn: self.$model.sections[9].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("musicchat", isOn: self.$model.sections[10].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("musichead", isOn: self.$model.sections[11].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        
                        Toggle("musicline", isOn: self.$model.sections[12].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("musicsampl", isOn: self.$model.sections[13].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                    }
                    VStack(alignment: .center) {
                        Text("Game")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("gamestream", isOn: self.$model.sections[14].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("gamechat", isOn: self.$model.sections[15].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("gamehead", isOn: self.$model.sections[16].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        
                        Toggle("gameline", isOn: self.$model.sections[17].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("gamesampl", isOn: self.$model.sections[18].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                    }
                    VStack(alignment: .center) {
                        Text("Console")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("consolestream", isOn: self.$model.sections[19].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("consolechat", isOn: self.$model.sections[20].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("consolehead", isOn: self.$model.sections[21].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        
                        Toggle("consoleline", isOn: self.$model.sections[22].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("consolesampl", isOn: self.$model.sections[23].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                    }
                    VStack(alignment: .center) {
                        Text("Line-In")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("lineinstream", isOn: self.$model.sections[24].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("lineinchat", isOn: self.$model.sections[25].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("lineinhead", isOn: self.$model.sections[26].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        
                        Toggle("lineinline", isOn: self.$model.sections[27].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("lineinsampl", isOn: self.$model.sections[28].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                    }
                    VStack(alignment: .center) {
                        Text("System")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("systemstream", isOn: self.$model.sections[29].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("systemchat", isOn: self.$model.sections[30].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("systemhead", isOn: self.$model.sections[31].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        
                        Toggle("systemline", isOn: self.$model.sections[32].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("systemsampl", isOn: self.$model.sections[33].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                    }
                    VStack(alignment: .center) {
                        Text("Samples")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                            .padding()
                        Toggle("samplstream", isOn: self.$model.sections[34].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("samplchat", isOn: self.$model.sections[35].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("samplhead", isOn: self.$model.sections[36].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        .padding(.bottom, 30)
                        
                        Toggle("samplline", isOn: self.$model.sections[37].enabled)
                        .padding(15)
                        .toggleStyle(CheckboxStyle())
                        
                        Toggle("samplsampl", isOn: $toggle)
                        .padding(15)
                        .toggleStyle(NotPossibleStyle())
                    }
                }
            }
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
class ListModel: ObservableObject {
    @Published var sections = RoutingListSection()
}
struct ListSection {
    var label: String
    var enabled: Bool {
        didSet {
            if label == "micstream" {
                ToggleRouting(chanin: "microphone", chanout: "broadcast-mix", state: enabled)
            }
            if label == "micchat" {
                ToggleRouting(chanin: "microphone", chanout: "chat-mic", state: enabled)
            }
            if label == "michead" {
                ToggleRouting(chanin: "microphone", chanout: "headphones", state: enabled)
            }
            if label == "micline" {
                ToggleRouting(chanin: "microphone", chanout: "line-out", state: enabled)
            }
            if label == "micsampl" {
                ToggleRouting(chanin: "microphone", chanout: "sampler", state: enabled)
            }
            
            
            
            if label == "chatstream" {
                ToggleRouting(chanin: "chat", chanout: "stream-mix", state: enabled)
            }
            if label == "chathead" {
                ToggleRouting(chanin: "chat", chanout: "headphones", state: enabled)
            }
            if label == "chatline" {
                ToggleRouting(chanin: "chat", chanout: "line-out", state: enabled)
            }
            if label == "chatsampl" {
                ToggleRouting(chanin: "chat", chanout: "sampler", state: enabled)
            }
            
            
            
            if label == "musicstream" {
                ToggleRouting(chanin: "music", chanout: "broadcast-mix", state: enabled)
            }
            if label == "musicchat" {
                ToggleRouting(chanin: "music", chanout: "chat-mic", state: enabled)
            }
            if label == "musichead" {
                ToggleRouting(chanin: "music", chanout: "headphones", state: enabled)
            }
            if label == "musicline" {
                ToggleRouting(chanin: "music", chanout: "line-out", state: enabled)
            }
            if label == "musicsampl" {
                ToggleRouting(chanin: "music", chanout: "sampler", state: enabled)
            }
            
            
            
            if label == "gamestream" {
                ToggleRouting(chanin: "game", chanout: "broadcast-mix", state: enabled)
            }
            if label == "gamechat" {
                ToggleRouting(chanin: "game", chanout: "chat-mic", state: enabled)
            }
            if label == "gamehead" {
                ToggleRouting(chanin: "game", chanout: "headphones", state: enabled)
            }
            if label == "gameline" {
                ToggleRouting(chanin: "game", chanout: "line-out", state: enabled)
            }
            if label == "gamesampl" {
                ToggleRouting(chanin: "game", chanout: "sampler", state: enabled)
            }
            
            
            
            if label == "consolestream" {
                ToggleRouting(chanin: "console", chanout: "broadcast-mix", state: enabled)
            }
            if label == "consolechat" {
                ToggleRouting(chanin: "console", chanout: "chat-mic", state: enabled)
            }
            if label == "consolehead" {
                ToggleRouting(chanin: "console", chanout: "headphones", state: enabled)
            }
            if label == "consoleline" {
                ToggleRouting(chanin: "console", chanout: "line-out", state: enabled)
            }
            if label == "consolesampl" {
                ToggleRouting(chanin: "console", chanout: "sampler", state: enabled)
            }
            
            
            
            if label == "lineinstream" {
                ToggleRouting(chanin: "line-in", chanout: "sampler", state: enabled)
            }
            if label == "lineinchat" {
                ToggleRouting(chanin: "line-in", chanout: "sampler", state: enabled)
            }
            if label == "lineinhead" {
                ToggleRouting(chanin: "line-in", chanout: "sampler", state: enabled)
            }
            if label == "lineinline" {
                ToggleRouting(chanin: "line-in", chanout: "sampler", state: enabled)
            }
            if label == "lineinsampl" {
                ToggleRouting(chanin: "line-in", chanout: "sampler", state: enabled)
            }
            
            
            if label == "systemstream" {
                ToggleRouting(chanin: "system", chanout: "sampler", state: enabled)
            }
            if label == "systemchat" {
                ToggleRouting(chanin: "system", chanout: "sampler", state: enabled)
            }
            if label == "systemhead" {
                ToggleRouting(chanin: "system", chanout: "sampler", state: enabled)
            }
            if label == "systemline" {
                ToggleRouting(chanin: "system", chanout: "sampler", state: enabled)
            }
            if label == "systemsampl" {
                ToggleRouting(chanin: "system", chanout: "sampler", state: enabled)
            }
            
            if label == "samplstream" {
                ToggleRouting(chanin: "samples", chanout: "broadcast-mix", state: enabled)
            }
            if label == "samplchat" {
                ToggleRouting(chanin: "samples", chanout: "chat-mic", state: enabled)
            }
            if label == "samplhead" {
                ToggleRouting(chanin: "samples", chanout: "headphones", state: enabled)
            }
            if label == "samplline" {
                ToggleRouting(chanin: "samples", chanout: "line-out", state: enabled)
            }
        }
    }
}
