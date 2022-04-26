//
//  ControlView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//

import SwiftUI
import ShellOut

struct ControlView: View {
    @State private var system: Double = 0
    @State private var music: Double = 0
    @State private var game: Double = 0
    @State private var chat: Double = 0
    @State private var linein: Double = 0
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
    var body: some View {
        HStack(alignment: .top, spacing: 10){
            VStack(){
                Slider(value: $system, in: 0...255).onChange(of: self.system) { newProgress in
                    do {
                    let roundedvalue = String(format: "%.0f", newProgress)
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--system-volume \(roundedvalue)"])
                    print(output)
                        
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
            Slider(value: $music, in: 0...255).onChange(of: self.music) { newProgress in
                do {
                let roundedvalue = String(format: "%.0f", newProgress)
                let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--music-volume \(roundedvalue)"])
                print(output)
                    
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
            Slider(value: $game, in: 0...255).onChange(of: self.game) { newProgress in
                do {
                let roundedvalue = String(format: "%.0f", newProgress)
                let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--game-volume \(roundedvalue)"])
                print(output)
                    
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
            Slider(value: $linein, in: 0...255).onChange(of: self.linein) { newProgress in
                do {
                let roundedvalue = String(format: "%.0f", newProgress)
                let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--line-in-volume \(roundedvalue)"])
                print(output)
                    
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
        }
        .padding(120)
        HStack(alignment: .top, spacing: 10){
            Picker("Channel A", selection: $selectedSliderA) {
                Text("System").tag("system")
                Text("Music").tag("music")
                Text("Game").tag("game")
                Text("Chat").tag("chat")
                Text("Line-In").tag("line-in")
            }.onChange(of: self.selectedSliderA, perform: { newValue in
                do {
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--fader-a \(self.selectedSliderA)"])
                print(output)
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    alertMessage = error.message
                    showingAlert = true
                }
            })
            Picker("Channel B", selection: $selectedSliderB) {
                Text("System").tag("system")
                Text("Music").tag("music")
                Text("Game").tag("game")
                Text("Chat").tag("chat")
                Text("Line-In").tag("line-in")
            }.onChange(of: self.selectedSliderB, perform: { newValue in
                do {
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--fader-b \(self.selectedSliderB)"])
                print(output)
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    alertMessage = error.message
                    showingAlert = true
                }
            })
            Picker("Channel C", selection: $selectedSliderC) {
                Text("System").tag("system")
                Text("Music").tag("music")
                Text("Game").tag("game")
                Text("Chat").tag("chat")
                Text("Line-In").tag("line-in")
            }.onChange(of: self.selectedSliderC, perform: { newValue in
                do {
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--fader-c \(self.selectedSliderC)"])
                print(output)
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    alertMessage = error.message
                    showingAlert = true
                }
            })
            Picker("Channel D", selection: $selectedSliderD) {
                Text("System").tag("system")
                Text("Music").tag("music")
                Text("Game").tag("game")
                Text("Chat").tag("chat")
                Text("Line-In").tag("line-in")
            }.onChange(of: self.selectedSliderD, perform: { newValue in
                do {
                    let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-client", arguments: ["--fader-d \(self.selectedSliderD)"])
                print(output)
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    alertMessage = error.message
                    showingAlert = true
                }
            })
        }
        .alert("ERROR", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
        } message: {
            Text("Is the daemon installed ?")
        }
    }
}
