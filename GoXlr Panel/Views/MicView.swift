//
//  MicView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 5/12/22.
//

import SwiftUI
import ShellOut
import UniformTypeIdentifiers

struct MicView: View {
    @State var tabname: String? = "Mic"
    @State var showFileChooser = false
    let profiletype = UTType(filenameExtension: "goxlr")
    
    @State private var dynamicgain: Double = 0
    @State private var condensergain: Double = 0
    @State private var jackgain: Double = 0
    
    func InitialmicUpdate() {
        
    }
    
    var body: some View {
        VStack(alignment: .center) {
            
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(alignment: .top, spacing: 10){
                            VStack(){
                                Slider(value: $dynamicgain, in: 0...72){ newProgress in
                                    
                                    let roundedvalue = String(format: "%.0f", dynamicgain)
                                    print(ClientCommand(arg1: "--dynamic-gain", arg2:  roundedvalue))
                                        
                                }.rotationEffect(.degrees(-90.0), anchor: .center)
                                    .padding(.bottom, 50)
                                    .frame(width: 100.0)
                            Text(String(dynamicgain) + "db")
                            Text("Dynamic Gain")
                            }
                            VStack(){
                                Slider(value: $condensergain, in: 0...72){ newProgress in
                                    
                                    let roundedvalue = String(format: "%.0f", condensergain)
                                    print(ClientCommand(arg1: "--condenser-gain", arg2:  roundedvalue))
                                }.rotationEffect(.degrees(-90.0), anchor: .center)
                                    .padding(.bottom, 50)
                                    .frame(width: 100.0)
                            Text(String(condensergain) + "db")
                            Text("Condenser Gain")
                            }
                            VStack(){
                            Slider(value: $jackgain, in: 0...72){ newProgress in
                                let roundedvalue = String(format: "%.0f", jackgain)
                                print(ClientCommand(arg1: "--jack-gain", arg2:  roundedvalue))
                            }.rotationEffect(.degrees(-90.0), anchor: .center)
                                    .padding(.bottom, 50)
                                    .frame(width: 100.0)
                            Text(String(jackgain) + "db")
                            Text("Jack Gain")
                            }
                    
                        }
                        .padding(.top, 40)
                        .onAppear(perform: InitialmicUpdate)
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
