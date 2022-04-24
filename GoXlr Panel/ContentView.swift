//
//  ContentView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 24/04/2022.
//

import SwiftUI
import ShellOut

struct ContentView: View {
    @State private var system: Double = 0
    @State private var music: Double = 0
    @State private var game: Double = 0
    @State private var chat: Double = 0
    @State private var linein: Double = 0
    enum SoundSlider: String, CaseIterable, Identifiable {
        case linein, system, game, chat, music, slider
        var id: Self { self }
    }

    @State private var selectedSlider: String = "system"
    var body: some View {
        Text("GoXlr test panel")
            .padding()
        HStack(alignment: .top, spacing: 10){
            VStack(){
                Slider(value: $system, in: 0...255).onChange(of: self.system) { newProgress in
                    do {
                    let roundedvalue = String(format: "%.0f", newProgress)
                    let output = try shellOut(to: "/Users/ade/.cargo/bin/goxlr-client", arguments: ["--system-volume \(roundedvalue)"])
                    print(output)
                        
                    } catch {
                        let error = error as! ShellOutError
                        print(error.message) // Prints STDERR
                        print(error.output) // Prints STDOUT
                        
                    }
                }
            Text("System")
            }
            VStack(){
            Slider(value: $music, in: 0...255).onChange(of: self.music) { newProgress in
                do {
                let roundedvalue = String(format: "%.0f", newProgress)
                let output = try shellOut(to: "/Users/ade/.cargo/bin/goxlr-client", arguments: ["--music-volume \(roundedvalue)"])
                print(output)
                    
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    
                }
            }
                
            Text("Music")
            }
            VStack(){
            Slider(value: $game, in: 0...255).onChange(of: self.game) { newProgress in
                do {
                let roundedvalue = String(format: "%.0f", newProgress)
                let output = try shellOut(to: "/Users/ade/.cargo/bin/goxlr-client", arguments: ["--game-volume \(roundedvalue)"])
                print(output)
                    
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    
                }
            }
            Text("Game")
            }
            VStack(){
            Slider(value: $linein, in: 0...255).onChange(of: self.linein) { newProgress in
                do {
                let roundedvalue = String(format: "%.0f", newProgress)
                let output = try shellOut(to: "/Users/ade/.cargo/bin/goxlr-client", arguments: ["--line-in-volume \(roundedvalue)"])
                print(output)
                    
                } catch {
                    let error = error as! ShellOutError
                    print(error.message) // Prints STDERR
                    print(error.output) // Prints STDOUT
                    
                }
            }
            Text("Line-In")
            }
        }
        HStack(alignment: .top, spacing: 10){
            Picker("Channel A", selection: $selectedSlider) {
                Text("System").tag("system")
                Text("Music").tag("music")
                Text("Game").tag("game")
                Text("Chat").tag("chat")
                Text("Line-In").tag("line-in")
            }
            Picker("Channel B", selection: $selectedSlider) {
                Text("System").tag("system")
                Text("Music").tag("music")
                Text("Game").tag("game")
                Text("Chat").tag("chat")
                Text("Line-In").tag("line-in")
            }
            Picker("Channel C", selection: $selectedSlider) {
                Text("System").tag("system")
                Text("Music").tag("music")
                Text("Game").tag("game")
                Text("Chat").tag("chat")
                Text("Line-In").tag("line-in")
            }
            Picker("Channel D", selection: $selectedSlider) {
                Text("System").tag("system")
                Text("Music").tag("music")
                Text("Game").tag("game")
                Text("Chat").tag("chat")
                Text("Line-In").tag("line-in")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .pickerStyle(.segmented)
            .padding(.horizontal, 90.0)
        
        
    }
}
