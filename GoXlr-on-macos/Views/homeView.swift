//
//  homeView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 07/07/2022.
//
import SwiftUI
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
            
            Text("Connect your GoXlr to get started")
                .padding(.top)
                .font(.title3)
            
        }
            .navigationTitle(tabname!)
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
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {showFileChooser.toggle()}, label: {
                        Text("Load Profile")
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {MixerStatus().selectedDevice.SaveProfile()}, label: {
                        Text("Save Profile")
                    })
                }
            }
                
    }
}
