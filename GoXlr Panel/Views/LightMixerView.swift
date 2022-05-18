//
//  LightMixerView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 5/13/22.
//
import SwiftUI
import ShellOut
import UniformTypeIdentifiers



struct LightMixerView: View {
    @State var tabname: String? = "Mixer Lightning"
    @State var showFileChooser = false
    let profiletype = UTType(filenameExtension: "goxlr")
    
    @State private var lighta: String = "/"
    @State private var lightb: String = "/"
    @State private var lightc: String = "/"
    @State private var lightd: String = "/"
    
    let graycolor =  Color(white: 130, opacity: 0.03)
    
    var body: some View {
        ScrollView {
            HStack(alignment: .center) {
                
                VStack(){
                    Text("Fader A")
                    Picker("", selection: $lighta) {
                        Text("Gradient").tag("gradient")
                        Text("Gradient Meter").tag("gradient-meter")
                        Text("Meter").tag("meter")
                        Text("Two Colour").tag("two-colour")
                    }.onChange(of: self.lighta, perform: { newValue in
                        print(ComplexClientCommand(arg1: "faders", arg2:  "display", arg3:"a", arg4: self.lighta))
                    })
                }.padding()
                    .background(graycolor)
                VStack(){
                    Text("Fader B")
                    Picker("", selection: $lightb) {
                        Text("Gradient").tag("gradient")
                        Text("Gradient Meter").tag("gradient-meter")
                        Text("Meter").tag("meter")
                        Text("Two Colour").tag("two-colour")
                    }.onChange(of: self.lightb, perform: { newValue in
                        print(ComplexClientCommand(arg1: "faders", arg2:  "display", arg3:"b", arg4: self.lightb))
                    })
                }.padding()
                    .background(graycolor)
                VStack(){
                    Text("Fader C")
                    Picker("", selection: $lightc) {
                        Text("Gradient").tag("gradient")
                        Text("Gradient Meter").tag("gradient-meter")
                        Text("Meter").tag("meter")
                        Text("Two Colour").tag("two-colour")
                    }.onChange(of: self.lightc, perform: { newValue in
                        print(ComplexClientCommand(arg1: "faders", arg2:  "display", arg3:"c", arg4: self.lightc))
                    })
                }.padding()
                    .background(graycolor)
                VStack(){
                    Text("Fader D")
                    Picker("", selection: $lightd) {
                        Text("Gradient").tag("gradient")
                        Text("Gradient Meter").tag("gradient-meter")
                        Text("Meter").tag("meter")
                        Text("Two Colour").tag("two-colour")
                    }.onChange(of: self.lightd, perform: { newValue in
                        print(ComplexClientCommand(arg1: "faders", arg2:  "display", arg3:"d", arg4: self.lightd))
                    })
                }.padding()
                    .background(graycolor)
            }.padding(.top, 70)
                .padding(.bottom, 10)
                .padding(.left, 70)
                .padding(.right, 70)
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
