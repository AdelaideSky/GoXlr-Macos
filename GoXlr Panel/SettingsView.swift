//
//  SettingsView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//

import SwiftUI
import ShellOut
import SimplyCoreAudio
let simplyCA = SimplyCoreAudio()

struct SettingsView: View {
    @State private var showingAlert = false
    @State private var showingReminder = false
    @State private var alertMessage = "Unspecified error"
    let usrPath = FileManager.default.homeDirectoryForCurrentUser
    
    var body: some View {
        Button("Launch Daemon") {
            do {
                let output = try shellOut(to: "\(usrPath.path)/.cargo/bin/goxlr-daemon", arguments: [""])
            print(output)
            } catch {
                let error = error as! ShellOutError
                print(error.message) // Prints STDERR
                print(error.output) // Prints STDOUT
                alertMessage = error.message
                showingAlert = true
                
            }
        }.padding(19)
        Text("⬇︎ Buttons that can break something if you use them twice (y'know if that worked don't re-click them) ⬇︎")
            .bold()
            .italic()
            .padding()
        Button("Create audio outputs") {
            showingReminder = true
            
        }
        .alert("Please put the GoXlr as default system output", isPresented: $showingReminder) {
                    Button("Yes", role: .cancel) {
                        let goxlr = simplyCA.defaultOutputDevice
                        let system = simplyCA.createAggregateDevice(masterDevice: goxlr!, secondDevice: goxlr, named: "System", uid: "system")
                        system?.setPreferredChannelsForStereo(channels: StereoPair(left: 1, right: 2), scope: Scope.output)
                        let game = simplyCA.createAggregateDevice(masterDevice: goxlr!, secondDevice: goxlr, named: "Game", uid: "game")
                        game?.setPreferredChannelsForStereo(channels: StereoPair(left: 3, right: 4), scope: Scope.output)
                        let chat = simplyCA.createAggregateDevice(masterDevice: goxlr!, secondDevice: goxlr, named: "Chat", uid: "chat")
                        chat?.setPreferredChannelsForStereo(channels: StereoPair(left: 5, right: 6), scope: Scope.output)
                        let music = simplyCA.createAggregateDevice(masterDevice: goxlr!, secondDevice: goxlr, named: "Music", uid: "music")
                        music?.setPreferredChannelsForStereo(channels: StereoPair(left: 7, right: 8), scope: Scope.output)
                        print("done")
                    }
        } message: {
            Text("Is the GoXlr the default output ?")
        }
        .alert("ERROR", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        Button("Install Daemon") {
            alertMessage = "Not yet implemented, you have to install it manually !"
            showingAlert=true
        }
    }
}
