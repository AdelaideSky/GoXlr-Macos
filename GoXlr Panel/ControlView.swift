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


import SwiftUI
import ShellOut

struct ControlView: View {
    
    func GetGoXlrState(want : String) -> String {
        var returnvalue = ""
        do {
            let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client")
            let informations = output.components(separatedBy: "\n")
            let type = String(String(informations[1]).suffix(5).prefix(4))
            let profile = String(informations[13])
            let fadera = String(informations[14]).substring(from: 20).lowercased()
            let faderb = String(informations[15]).substring(from: 20).lowercased()
            let faderc = String(informations[16]).substring(from: 20).lowercased()
            let faderd = String(informations[17]).substring(from: 20).lowercased()
            let micvolume = String(String(informations[18]).components(separatedBy: " ")[2].dropLast(1))
            let lineinvolume = String(String(informations[19]).components(separatedBy: " ")[2].dropLast(1))
            let consolevolume = String(String(informations[20]).components(separatedBy: " ")[2].dropLast(1))
            let systemvolume = String(String(informations[21]).components(separatedBy: " ")[2].dropLast(1))
            let gamevolume = String(String(informations[22]).components(separatedBy: " ")[2].dropLast(1))
            let chatvolume = String(String(informations[23]).components(separatedBy: " ")[2].dropLast(1))
            let samplevolume = String(String(informations[24]).components(separatedBy: " ")[2].dropLast(1))
            let musicvolume = String(String(informations[25]).components(separatedBy: " ")[2].dropLast(1))
            let headphonesvolume = String(String(informations[26]).components(separatedBy: " ")[2].dropLast(1))
            let micmonitorvolume = String(String(informations[27]).components(separatedBy: " ")[2].dropLast(1))
            let lineoutvolume = String(String(informations[28]).components(separatedBy: " ")[2].dropLast(1))

            
            if want == "type" {returnvalue = type}
            if want == "profile" {returnvalue = profile}
            if want == "fadera" {returnvalue = fadera}
            if want == "faderb" {returnvalue = faderb}
            if want == "faderc" {returnvalue = faderc}
            if want == "faderd" {returnvalue = faderd}
            if want == "micvolume" {returnvalue = micvolume}
            if want == "chatvolume" {returnvalue = chatvolume}
            if want == "musicvolume" {returnvalue = musicvolume}
            if want == "gamevolume" {returnvalue = gamevolume}
            if want == "consolevolume" {returnvalue = consolevolume}
            if want == "lineinvolume" {returnvalue = lineinvolume}
            if want == "lineoutvolume" {returnvalue = lineoutvolume}
            if want == "systemvolume" {returnvalue = systemvolume}
            if want == "samplevolume" {returnvalue = samplevolume}
            if want == "headphonesvolume" {returnvalue = headphonesvolume}
            if want == "micmonitorvolume" {returnvalue = micmonitorvolume}
            
        } catch {
            let error = error as! ShellOutError
            print(error.message) // Prints STDERR
            print(error.output) // Prints STDOUT
            alertMessage = error.message
            showingAlert = true
        }
        return(returnvalue)
    }
    
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
    



    @State private var showingAlert = false
    let usrPath = FileManager.default.homeDirectoryForCurrentUser
    enum SoundSlider: String, CaseIterable, Identifiable {
        case linein, system, game, chat, music, slider
        var id: Self { self }
    }

    @State private var selectedSliderA: String = "/"
    @State private var selectedSliderB: String = "/"
    @State private var selectedSliderC: String = "/"
    @State private var selectedSliderD: String = "/"
    @State private var alertMessage = "Unspecified error"
    func InitialUpdate() {
        selectedSliderA = GetGoXlrState(want: "fadera")
        selectedSliderB = GetGoXlrState(want: "faderb")
        selectedSliderC = GetGoXlrState(want: "faderc")
        selectedSliderD = GetGoXlrState(want: "faderd")
        var volume = 0
        volume = (Int(GetGoXlrState(want: "micvolume")) ?? 0) * 255 / 100
        mic = Double(volume)
        volume = (Int(GetGoXlrState(want: "chatvolume")) ?? 0) * 255 / 100
        chat = Double(volume)
        volume = (Int(GetGoXlrState(want: "musicvolume")) ?? 0) * 255 / 100
        music = Double(volume)
        volume = (Int(GetGoXlrState(want: "gamevolume")) ?? 0) * 255 / 100
        game = Double(volume)
        volume = (Int(GetGoXlrState(want: "consolevolume")) ?? 0) * 255 / 100
        console = Double(volume)
        volume = (Int(GetGoXlrState(want: "lineinvolume")) ?? 0) * 255 / 100
        linein = Double(volume)
        volume = (Int(GetGoXlrState(want: "lineoutvolume")) ?? 0) * 255 / 100
        lineout = Double(volume)
        volume = (Int(GetGoXlrState(want: "systemvolume")) ?? 0) * 255 / 100
        system = Double(volume)
        volume = (Int(GetGoXlrState(want: "samplevolume")) ?? 0) * 255 / 100
        sample = Double(volume)
        volume = (Int(GetGoXlrState(want: "headphonesvolume")) ?? 0) * 255 / 100
        headphones = Double(volume)
        volume = (Int(GetGoXlrState(want: "micmonitorvolume")) ?? 0) * 255 / 100
        micmonitor = Double(volume)
    }
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            VStack(){
                Slider(value: $mic, in: 0...255){ newProgress in
                    do {
                    let roundedvalue = String(format: "%.0f", mic)
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--mic-volume \(roundedvalue)"])
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        alertMessage = error.message
                        showingAlert = true
                        
                    }
                }
            Text("Mic")
            }
            VStack(){
                Slider(value: $chat, in: 0...255){ newProgress in
                    do {
                    let roundedvalue = String(format: "%.0f", chat)
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--chat-volume \(roundedvalue)"])
                        
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        alertMessage = error.message
                        showingAlert = true
                        
                    }
                }
            Text("Chat")
            }
            VStack(){
            Slider(value: $music, in: 0...255){ newProgress in
                do {
                let roundedvalue = String(format: "%.0f", music)
                let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--music-volume \(roundedvalue)"])
                    
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    alertMessage = error.message
                    showingAlert = true
                }
            }
                
            Text("Music")
            }
            VStack(){
            Slider(value: $game, in: 0...255){ newProgress in
                do {
                let roundedvalue = String(format: "%.0f", game)
                let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--game-volume \(roundedvalue)"])
                    
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    alertMessage = error.message
                    showingAlert = true
                    
                }
            }
            Text("Game")
            }
            VStack(){
            Slider(value: $console, in: 0...255){ newProgress in
                do {
                let roundedvalue = String(format: "%.0f", console)
                let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--console-volume \(roundedvalue)"])
                    
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    alertMessage = error.message
                    showingAlert = true
                    
                }
            }
            Text("Console")
            }
        }
        .padding(10)
        .onAppear(perform: InitialUpdate)
        HStack(alignment: .top, spacing: 10){
            VStack(){
            
            Slider(value: $linein, in: 0...255){ newProgress in
                do {
                let roundedvalue = String(format: "%.0f", linein)
                let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--line-in-volume \(roundedvalue)"])
                    
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    alertMessage = error.message
                    showingAlert = true
                    
                }
            }
            Text("Line-In")
                
            }
            VStack(){
            
            Slider(value: $lineout, in: 0...255){ newProgress in
                do {
                let roundedvalue = String(format: "%.0f", lineout)
                let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--line-out-volume \(roundedvalue)"])
                    
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    alertMessage = error.message
                    showingAlert = true
                    
                }
            }
            Text("Line-Out")
                
            }
            VStack(){
                Slider(value: $system, in: 0...255){ newProgress in
                    do {
                    let roundedvalue = String(format: "%.0f", system)
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--system-volume \(roundedvalue)"])
                        
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        alertMessage = error.message
                        showingAlert = true
                        
                    }
                }
            Text("System")
            }
            VStack(){
                Slider(value: $sample, in: 0...255){ newProgress in
                    do {
                    let roundedvalue = String(format: "%.0f", sample)
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--sample-volume \(roundedvalue)"])
                        
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        alertMessage = error.message
                        showingAlert = true
                        
                    }
                }
            Text("Sample")
            }
        }.padding(10)
            .onAppear(perform: InitialUpdate)
        HStack(alignment: .top, spacing: 10){
            VStack(){
                Slider(value: $headphones, in: 0...255){ newProgress in
                    do {
                    let roundedvalue = String(format: "%.0f", headphones)
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--headphones-volume \(roundedvalue)"])
                        
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        alertMessage = error.message
                        showingAlert = true
                        
                    }
                }
            Text("Headphones")
            }
            VStack(){
                Slider(value: $micmonitor, in: 0...255){ newProgress in
                    do {
                    let roundedvalue = String(format: "%.0f", micmonitor)
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--mic-monitor-volume \(roundedvalue)"])
                        
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        alertMessage = error.message
                        showingAlert = true
                        
                    }
                }
            Text("Mic Monitor")
            }
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
                    do {
                        let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--fader-a \(self.selectedSliderA)"])
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        alertMessage = error.message
                        showingAlert = true
                    }
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
                    do {
                        let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--fader-b \(self.selectedSliderB)"])
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        alertMessage = error.message
                        showingAlert = true
                    }
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
                    do {
                        let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--fader-c \(self.selectedSliderC)"])
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        alertMessage = error.message
                        showingAlert = true
                    }
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
                    do {
                        let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--fader-d \(self.selectedSliderD)"])
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        alertMessage = error.message
                        showingAlert = true
                    }
                })
            Text("Fader D")
            }
        }
        .padding(100)
        .alert("ERROR", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
        } message: {
            Text("Is the daemon installed ?")
        }
    }
}
