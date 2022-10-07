//
//  ProfilesView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 26/07/2022.
//

import Foundation
import SwiftUI



struct LoadProfileView: View {
    @EnvironmentObject var mixer: MixerStatus
    @State var defaultTab: String
    var body: some View {
        
        VStack(alignment: .center) {
            NavigationView {
                List {
                    Text("Profiles")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    Group{
                        NavigationLink(destination: profileDevice().environmentObject(mixer)) {
                            Text("Device profile")
                        }
                        NavigationLink(destination: profileMic().environmentObject(mixer)) {
                            Text("Mic profile")
                        }
                        
                    }
                    
                }
                .listStyle(SidebarListStyle())
                .frame(minWidth: 150, idealWidth: 250, maxWidth: 300)
                
                if defaultTab == "mic" {
                    profileMic().environmentObject(mixer)
                }
                else {
                    profileDevice().environmentObject(mixer)
                }
            }
        }.toolbar {
            ToolbarItem(placement: .cancellationAction) {
                Button("Exit") {
                    
                    mixer.profileSheet = false
                }
            }
        }
        .onAppear(perform: { mixer.updateProfiles() })
        .onDisappear(perform: {
            mixer.updateMixerStatus()
            mixer.updateFaderDetails()
            mixer.updateMicDetails()
        })
        .frame(width: 400, height: 350)
    }
}


struct profileDevice: View {
    @EnvironmentObject var mixer: MixerStatus
    
    @State private var alreadyFileShown = false
    @State private var newNameEditor = false
    @State private var dupliNameEditor = false
    @State private var deleteAlert = false
    
    
    @State private var newNameEditorString = ""
    @State private var dupliNameEditorString = ""
    
    @State private var rightClickSelected = ""


    
    
    var body: some View {
        Text("Device profiles").font(.system(.title2)).padding(.top, 3).padding(.right, 95).padding(.bottom, 15)
        VStack(alignment: .center, spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                VStack(alignment: .leading, spacing: 0) {
                    Text("Saved profiles")
                        .opacity(0.8)
                        .font(.system(.headline))
                        .padding(.top, 5)
                        .padding(.left, 10)
                        .padding(.bottom, 5)
                        
                    Divider().opacity(0.2)

                    List(mixer.profilesList, id: \.self, selection: $mixer.selectedProfile) { string in
                        ZStack(alignment: .leading) {
                            Rectangle().fill(Color.gray.opacity(0.001))
                            Text(string)
                        }.padding(.bottom, 0.5)
                            .padding(.top, 0.5)
                            .accentColor(Color.accentColor)
                            .gesture(TapGesture(count: 2).onEnded {
                                mixer.selectedDevice.LoadProfile(path: string)
                                mixer.profileSheet = false
                            })
                            .simultaneousGesture(TapGesture().onEnded {
                                mixer.selectedProfile = string
                            })
                            
                            .contextMenu {
                                Button(action: {
                                    mixer.selectedDevice.LoadProfile(path: string)
                                    mixer.profileSheet = false
                                }, label: {
                                    HStack {
                                        Text("Load")
                                        Spacer()
                                        Image(systemName: "doc.badge.arrow.up")
                                    }.foregroundColor(.red)
                                })
                                
                                Divider()
                                Button(role: .destructive, action: {
                                    rightClickSelected = string
                                    deleteAlert = true
                                }, label: {
                                    HStack {
                                        Text("Delete")
                                        Spacer()
                                        Image(systemName: "trash")
                                    }.foregroundColor(.red)
                                })
                                       
                                
                            }
                    }.listStyle(.automatic)
                        .backgroundStyle(.white.opacity(0))
                        .cornerRadius(15)
                        .contextMenu {
                            Button(action: {
                                newNameEditor = true
                            }, label: {
                                HStack {
                                    Text("New")
                                    Spacer()
                                    Image(systemName: "doc.badge.plus")
                                }.foregroundColor(.red)
                            })
                        }
                        .alert("Are you sure you want to delete \(rightClickSelected) ?", isPresented: $deleteAlert, actions: {
                            Button("Cancel", role: .cancel ) { deleteAlert = true }
                            Button("Delete", role: .destructive) {
                                mixer.selectedDevice.DeleteProfile(name: rightClickSelected)
                                deleteAlert = true
                                if let index = mixer.profilesList.firstIndex(of: rightClickSelected) {
                                    mixer.profilesList.remove(at: index)
                                }}
                        }, message: {
                            Text("If you delete this profile, you won't be able to recover it.")
                        })
                        
                }
            }.frame(width: 215, height:  mixer.selectedProfile != nil ? 180 : 230)
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                VStack(alignment: .center) {
                    if mixer.selectedProfile != nil {
                        HStack() {
                            Button("Load Profile") {
                                mixer.selectedDevice.LoadProfile(path: mixer.selectedProfile!)
                                mixer.profileSheet = false
                            }
                        }.controlSize(.large)
                        HStack() {
                            Button("New") {
                                newNameEditor = true
                            }
                            if mixer.selectedProfile == mixer.profile {
                                Button("Duplicate") {
                                    dupliNameEditor = true
                                }
                            }
                            
                        }.controlSize(.large)
                            .alert("Error", isPresented: $alreadyFileShown, actions: {
                                Button("Ok", role: .cancel) { alreadyFileShown = false }
                            }, message: {
                                Text("File already exists. Maybe try a other name ?")
                            })
                            .alert("Please enter a name for your profile", isPresented: $newNameEditor, actions: {
                                TextField("Profile name", text: $newNameEditorString).controlSize(.large)
                                Button("Cancel", role: .cancel) { newNameEditor = false }
                                Button("Ok") {
                                    if newNameEditorString != "" {
                                        let cmdrep = mixer.selectedDevice.NewProfile(name: newNameEditorString)
                                        if cmdrep.rawString()! == "{\n  \"Error\" : \"File already exists.\"\n}" {
                                            alreadyFileShown = true
                                        }
                                        mixer.profilesList.append(newNameEditorString)
                                    }
                                    
                                    newNameEditorString = ""
                                    newNameEditor = false }
                            })
                        
                            .alert("Please enter a name for your profile", isPresented: $dupliNameEditor, actions: {
                                TextField("Profile name", text: $dupliNameEditorString).controlSize(.large)
                                Button("Cancel", role: .cancel) { dupliNameEditor = false }
                                Button("Ok") {
                                    if dupliNameEditorString != "" {
                                        let cmdrep = mixer.selectedDevice.SaveProfileAs(name: dupliNameEditorString)
                                        if cmdrep.rawString()! == "{\n  \"Error\" : \"File already exists.\"\n}" {
                                            alreadyFileShown = true
                                        }
                                    }
                                    mixer.profilesList.append(dupliNameEditorString)
                                    dupliNameEditorString = ""
                                    dupliNameEditor = false }
                            })
                            
                    }
                    else {
                        HStack() {
                            Button("New") {
                                mixer.selectedDevice.NewProfile(name: "defo")
                            }
                        }.controlSize(.large)
                    }
                }
            }.frame(width: 215, height: mixer.selectedProfile != nil ? 90 : 40)
        }.padding(.bottom, 5)
           
    }
}

struct profileMic: View {
    @EnvironmentObject var mixer: MixerStatus
    
    @State var alreadyFileShown = false
    @State var newNameEditor = false
    @State var dupliNameEditor = false
    @State var deleteAlert = false
    
    
    @State var newNameEditorString = ""
    @State var dupliNameEditorString = ""
    
    @State var rightClickSelected = ""


    
    
    var body: some View {
        Text("Mic profiles").font(.system(.title2)).padding(.top, 3).padding(.right, 130).padding(.bottom, 15)
        VStack(alignment: .center, spacing: 15) {
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                VStack(alignment: .leading, spacing: 0) {
                    Text("Saved profiles")
                        .opacity(0.8)
                        .font(.system(.headline))
                        .padding(.top, 5)
                        .padding(.left, 10)
                        .padding(.bottom, 5)
                        
                    Divider().opacity(0.2)

                    List(mixer.micProfilesList, id: \.self, selection: $mixer.selectedMicProfile) { string in
                        ZStack(alignment: .leading) {
                            Rectangle().fill(Color.gray.opacity(0.001))
                            Text(string)
                        }.padding(.bottom, 0.5)
                            .padding(.top, 0.5)
                            .accentColor(Color.accentColor)
                            .frame(width: .infinity, height: .infinity)
                            .gesture(TapGesture(count: 2).onEnded {
                                mixer.selectedDevice.LoadMicProfile(path: string)
                                mixer.profileSheet = false
                            })
                            .simultaneousGesture(TapGesture().onEnded {
                                mixer.selectedMicProfile = string
                            })
                            
                            .contextMenu {
                                Button(action: {
                                    mixer.selectedDevice.LoadMicProfile(path: string)
                                    mixer.profileSheet = false
                                }, label: {
                                    HStack {
                                        Text("Load")
                                        Spacer()
                                        Image(systemName: "doc.badge.arrow.up")
                                    }.foregroundColor(.red)
                                })
                                
                                Divider()
                                Button(role: .destructive, action: {
                                    rightClickSelected = string
                                    deleteAlert = true
                                }, label: {
                                    HStack {
                                        Text("Delete")
                                        Spacer()
                                        Image(systemName: "trash")
                                    }.foregroundColor(.red)
                                })
                                       
                                
                            }
                    }.listStyle(.automatic)
                        .backgroundStyle(.white.opacity(0))
                        .cornerRadius(15)
                        .contextMenu {
                            Button(action: {
                                newNameEditor = true
                            }, label: {
                                HStack {
                                    Text("New")
                                    Spacer()
                                    Image(systemName: "doc.badge.plus")
                                }.foregroundColor(.red)
                            })
                        }
                        .alert("Are you sure you want to delete \(rightClickSelected) ?", isPresented: $deleteAlert, actions: {
                            Button("Cancel", role: .cancel ) { deleteAlert = true }
                            Button("Delete", role: .destructive) {
                                mixer.selectedDevice.DeleteMicProfile(name: rightClickSelected)
                                deleteAlert = true
                                if let index = mixer.micProfilesList.firstIndex(of: rightClickSelected) {
                                    mixer.micProfilesList.remove(at: index)
                                }}
                        }, message: {
                            Text("If you delete this profile, you won't be able to recover it.")
                        })
                        
                }
            }.frame(width: 215, height:  mixer.selectedMicProfile != nil ? 180 : 230)
            ZStack {
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                VStack(alignment: .center) {
                    if mixer.selectedMicProfile != nil {
                        HStack() {
                            Button("Load Profile") {
                                mixer.selectedDevice.LoadMicProfile(path: mixer.selectedProfile!)
                                mixer.profileSheet = false
                            }
                        }.controlSize(.large)
                        HStack() {
                            Button("New") {
                                newNameEditor = true
                            }
                            if mixer.selectedMicProfile == mixer.micProfile {
                                Button("Duplicate") {
                                    dupliNameEditor = true
                                }
                            }
                            
                        }.controlSize(.large)
                            .alert("Error", isPresented: $alreadyFileShown, actions: {
                                Button("Ok", role: .cancel) { alreadyFileShown = false }
                            }, message: {
                                Text("File already exists. Maybe try a other name ?")
                            })
                            .alert("Please enter a name for your profile", isPresented: $newNameEditor, actions: {
                                TextField("Profile name", text: $newNameEditorString).controlSize(.large)
                                Button("Cancel", role: .cancel) { newNameEditor = false }
                                Button("Ok") {
                                    if newNameEditorString != "" {
                                        let cmdrep = mixer.selectedDevice.NewMicProfile(name: newNameEditorString)
                                        if cmdrep.rawString()! == "{\n  \"Error\" : \"File already exists.\"\n}" {
                                            alreadyFileShown = true
                                        }
                                        mixer.micProfilesList.append(newNameEditorString)
                                    }
                                    
                                    newNameEditorString = ""
                                    newNameEditor = false }
                            })
                        
                            .alert("Please enter a name for your profile", isPresented: $dupliNameEditor, actions: {
                                TextField("Mic profile name", text: $dupliNameEditorString).controlSize(.large)
                                Button("Cancel", role: .cancel) { dupliNameEditor = false }
                                Button("Ok") {
                                    if dupliNameEditorString != "" {
                                        let cmdrep = mixer.selectedDevice.SaveMicProfileAs(name: dupliNameEditorString)
                                        if cmdrep.rawString()! == "{\n  \"Error\" : \"File already exists.\"\n}" {
                                            alreadyFileShown = true
                                        }
                                    }
                                    mixer.micProfilesList.append(dupliNameEditorString)
                                    dupliNameEditorString = ""
                                    dupliNameEditor = false }
                            })
                            
                    }
                    else {
                        HStack() {
                            Button("New") {
                                mixer.selectedDevice.NewProfile(name: "defo")
                            }
                        }.controlSize(.large)
                    }
                }
            }.frame(width: 215, height: mixer.selectedMicProfile != nil ? 90 : 40)
        }.padding(.bottom, 5)
           
    }
}
