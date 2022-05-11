//
//  SettingsView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//

import SwiftUI
import ShellOut

struct HomeView: View {
    @State var tabname: String? = "Home"
    
    func ClientCommand(arg1: String, arg2: String) -> String {
        let task = Process()
        let pipe = Pipe()
        let bundle = Bundle.main
        let client = bundle.url(forResource: "goxlr-client", withExtension: nil)
        guard client != nil else {
            print("GoXlr-Client executable could not be found!")
            return("GoXlr-Client executable could not be found!")
        }
        task.executableURL = client!
        if arg1 != "" && arg2 != "" {
                task.arguments = [arg1, arg2]
        }
        if arg1 != "" && arg2 == "" {
            task.arguments = [arg1]
        }
        task.standardOutput = pipe
        task.standardError = pipe
        do {
            try task.run()
            print("Command '\(arg1)' executed successfully!")
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8)!
            return(output)
            
        } catch {
            print("Error running Command: \(error)")
        }
        
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        
        return(output)
    }
    
    func Daemon(command: String) {
        let task = Process()
        let pipe = Pipe()
        let bundle = Bundle.main
        let goxlrdaemon = bundle.url(forResource: "goxlr-daemon", withExtension: nil)
        task.executableURL = goxlrdaemon!
        task.standardOutput = pipe
        task.standardError = pipe
        if command == "start" {
            Task {
                do {
                    try task.run()
                    let data = pipe.fileHandleForReading.readDataToEndOfFile()
                    let output = String(data: data, encoding: .utf8)!
                    print(output)
                    print("Daemon started successfully!")
                } catch {
                    print("Error launching Daemon: \(error)")
                }
            }
        }
        else if command == "stop" {
            do {
                let output = try shellOut(to: "/usr/bin/killall", arguments: ["goxlr-daemon"])
            print(output)
            } catch {
                let error = error as! ShellOutError
                print(error.message) // Prints STDERR
                print(error.output) // Prints STDOUT
            }
        }
        else {
        }
    }
    
    func GoXlrConnected() -> String {
        if ClientCommand(arg1: "", arg2: "").contains("Error: Could not connect to the GoXLR daemon process") {
        return("no")
        }
        else if ClientCommand(arg1: "", arg2: "").contains("Error: Multiple GoXLR devices are connected, please specify which one to control") {
            return("no")
        }
        else {
            return("yes")
        }
    }
    
    func LaunchDaemon() {
        Daemon(command:"start")
        usleep(20000)
    }
    
    var body: some View {
        VStack(alignment: .center) {
            Text("👋")
                .font(.system(size: 60))
            Text("Welcome " + NSFullUserName() + " !")
                .bold()
                .font(.system(size: 45))
                .fontWeight(.heavy)
            if GoXlrConnected() == "yes" {
                Text("Your GoXlr is connected and initialized")
                    .padding(.top)
                    .font(.title3)
            }
            if GoXlrConnected() == "no" {
                Text("Connect your GoXlr to get started")
                    .padding(.top)
                    .font(.title3)
            }
            if GoXlrConnected() == "nodaemon" {
                Text("The daemon isn't started...")
                    .padding(.top)
                    .font(.title3)
            }
            
        }.onAppear(perform: LaunchDaemon)
            .navigationTitle(tabname!)
                
    }
}
