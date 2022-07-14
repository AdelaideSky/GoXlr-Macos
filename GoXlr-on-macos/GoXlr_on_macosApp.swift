//
//  GoXlr_on_macosApp.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 02/07/2022.
//

import SwiftUI

import UniformTypeIdentifiers

@main
struct GoXlr_on_macosApp: App {
    @State var currentNumber: String = "1"
        
        var body: some Scene {
            WindowGroup("GoXLr Panel", id: "manager") {
                 ContentView()
                    .frame(minWidth: 1000, idealWidth: 1200, minHeight: 520, idealHeight: 530)
            }
            MenuBarExtra(currentNumber, image: "devices.goxlr.logo") {
                
                OpenWindowButton()
                
            }.menuBarExtraStyle(.window)
                .commands {
                  CommandMenu("My Top Menu") {
                    Button("Sub Menu Item") { print("You pressed sub menu.") }
                      .keyboardShortcut("S")
                  }
                  CommandGroup(replacing: .pasteboard) {
                    Button("Cut") { print("Cutting something...") }
                      .keyboardShortcut("X")
                    Button("Copy") { print("Copying something...") }
                      .keyboardShortcut("C")
                    Button("Paste") { print("Pasting something...") }
                      .keyboardShortcut("V")
                    Button("Paste and Match Style") { print("Pasting and Matching something...") }
                      .keyboardShortcut("V", modifiers: [.command, .option, .shift])
                    Button("Delete") { print("Deleting something...") }
                      .keyboardShortcut(.delete)
                    Button("Select All") { print("Selecting something...") }
                      .keyboardShortcut("A")
                  }
                }

            
        }
}



struct OpenWindowButton: View {
    @Environment(\.openWindow) private var openWindow
    @State private var select = ""
    @State var showFileChooser = false
    let profiletype = UTType(filenameExtension: "goxlr")
    
        var body: some View {
            VStack(spacing: 16) {
                HStack {
                    Button {
                        print(testingParsing())} label: {
                        Text("Test things")
                            .frame(maxWidth: .infinity)}
                    Picker("", selection: $select) {
                        Text("abcdeegrgr").tag("abcdeegdrgr")
                        Text("abcdeegrgr").tag("abcdeezgrgr")
                        Text("abcdeegrgr").tag("abcdeegrgra")
                        Text("abcdeegrgr").tag("abcdgeegrgr")
                    }
                }
                    .controlSize(.large)
                
                

                HStack {
                    
                    Button {
                        MixerStatus().selectedDevice.Sleep() } label: {
                            Label("Sleep", systemImage: "powersleep")}.keyboardShortcut(.escape)
                    
                    Button {
                        MixerStatus().selectedDevice.SaveProfile()} label: {
                        Text("Save Profile")
                            .frame(maxWidth: .infinity)}.keyboardShortcut("s")
                    
                    Button {
                        showFileChooser = true} label: {
                        Text("Load Profile")
                            .frame(maxWidth: .infinity)}.keyboardShortcut("o")

                }.labelStyle(.iconOnly)
                .controlSize(.large)
                
                HStack {
                    
                    Button {
                        openWindow(id: "manager")} label: {
                        Text("Configure GoXlr")
                            .frame(maxWidth: .infinity)}.keyboardShortcut(";")

                    ShareLink(items: ["SharingContent"])
                    Button() {
                        NSApplication.shared.terminate(nil)
                    } label: {
                        Label("Power", systemImage: "power")}.keyboardShortcut("q")
                }
                .labelStyle(.iconOnly)
                .controlSize(.large)
            }
            .fileImporter(isPresented: $showFileChooser, allowedContentTypes: [profiletype!], onCompletion: { result in
            print("Picked: \(result)")
            do{
                var fileUrl = try result.get()
                fileUrl = fileUrl.deletingPathExtension()
                let strfileUrl = fileUrl.path
                MixerStatus().selectedDevice.LoadProfile(path: strfileUrl)
                            
            } catch{
                                        
                print ("error reading")
                print (error.localizedDescription)
            }
        })
            .padding(16)
        }
}
