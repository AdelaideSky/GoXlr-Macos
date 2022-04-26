//
//  SettingsView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//

import SwiftUI
import ShellOut

struct SettingsView: View {
    @State private var showingAlert = false
    @State private var alertMessage = "Unspecified error"
    let usrPath = FileManager.default.homeDirectoryForCurrentUser

    var body: some View {
        Text("OUI")
            .padding()
        Button("Create audio outputs") {
            print("\(usrPath).cargo/bin/goxlr-daemon")
        }
        .alert("ERROR", isPresented: $showingAlert) {
                    Button("OK", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
        Button("Install Daemon") {
            do {
                _ = try shellOut(to: "/usr/local/bin/brew", arguments: ["install libusb"])
                _ = try shellOut(to: "/usr/bin/git", arguments: ["clone https://github.com/GoXLR-on-Linux/GoXLR-Utility.git"])

            
            } catch {
                let error = error as! ShellOutError
                print(error.message) // Prints STDERR
                print(error.output) // Prints STDOUT
                alertMessage = error.message
                showingAlert = true
            }
        }
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
        }
    }
}
