//
//  SettingsView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//

import SwiftUI
import ShellOut
import UniformTypeIdentifiers

struct HomeView: View {
    @State var tabname: String? = "Home"
    @State var showFileChooser = false
    let profiletype = UTType(filenameExtension: "goxlr")
    
    
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
