//
//  MicProfilesElement.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 20/04/2023.
//

import SwiftUI
import GoXlrKit

struct MicProfilesElement: View {
    @ObservedObject var files = GoXlr.shared.status!.data.status.files
    @ObservedObject var mixer = GoXlr.shared.mixer!
    
    @State var showDeleteAlert: Bool = false
    
    var body: some View {
        Section(content: {
            VStack {
                if files.micProfiles.isEmpty {
//                    ContentUnavailableView("No mic profile yet !", systemImage: "tray", description: Text("Try adding a profile by clicking the \"New\" button below, or go to settings to recover the default ones !"))
                    HStack {
                        Spacer()
                        Text("No mic profile yet !")
                        Text("Try adding a profile by clicking the \"New\" button below, or go to settings to recover the default ones !")
                        Spacer()
                    }.foregroundStyle(.secondary)
                        .font(.caption)
                } else {
                    List(files.micProfiles.prefix(files.micProfiles.count == 6 ? 6 : 5), id:\.self, selection: $mixer.micProfileName) { profile in
                        MicProfileRowElement(profile)
                            .tag(profile)
                    }.listStyle(.inset)
                        .padding(.bottom, files.micProfiles.count > 6 ? -13 : 0)
                    if files.micProfiles.count > 6 {
                        DisclosureGroup("More...") {
                            List(files.micProfiles.dropFirst(5), id:\.self, selection: $mixer.micProfileName) { profile in
                                MicProfileRowElement(profile)
                                    .tag(profile)
                            }.listStyle(.inset)
                                .padding(.horizontal, -10)
                        }.padding(.horizontal, 10)
                    }
                }
            }
                
        }, header: {
            HStack {
                Text("Mic Profiles")
                Spacer()
                Button(action: {
                    URL(fileURLWithPath: GoXlr.shared.status!.data.status.paths.micProfileDirectory).showInFinder()
                }, label: {
                    Image(systemName: "folder.fill")
                }).buttonStyle(.borderless)
            }
        })
        Section {
            MicProfileActionsRowElement()
        }
    }
}
struct MicProfileRowElement: View {
    
    @State var profile: String
    @State var showDeleteAlert: Bool = false
    
    @State var showLoadActiveAlert: Bool = false

    init(_ profile: String) {
        self.profile = profile
    }
    
    var body: some View {
        HStack {
            Text(profile)
            Spacer()
            Menu(content: {
                Button("Load profile") {
                    if profile != GoXlr.shared.mixer!.micProfileName {
                        GoXlr.shared.mixer!.micProfileName = profile
                    } else {
                        showLoadActiveAlert = true
                    }
                }
                Button("Delete profile") {
                    showDeleteAlert = true
                }.disabled(GoXlr.shared.status!.data.status.files.micProfiles.count <= 1)
            }, label: {
                Image(systemName: "ellipsis")
                    .font(.headline)
            }).menuStyle(.borderlessButton)
                .menuIndicator(.hidden)
                .frame(width: 20)
        }.alert("Are you sure you want to delete the profile \(profile)", isPresented: $showDeleteAlert) {
            
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if GoXlr.shared.mixer!.micProfileName == profile {
                    GoXlr.shared.mixer!.micProfileName = GoXlr.shared.status!.data.status.files.micProfiles.first!
                }
                GoXlr.shared.command(.DeleteMicProfile(profile))
            }
        }
        .alert("Are you sure you want to reload the profile \(profile)", isPresented: $showLoadActiveAlert, actions: {
            
            Button("Cancel", role: .cancel) {}
            Button("Reload", role: .destructive) {
                GoXlr.shared.command(.LoadMicProfile(profile, true))
            }
        }, message: {
            Text("You will loose all modifications.")
        })
    }
}
struct MicProfileActionsRowElement: View {
    @ObservedObject var mixer = GoXlr.shared.mixer!
    
    @State var showSaveAlert: Bool = false
    @State var showNewSheet: Bool = false
    @State var showDuplicateSheet: Bool = false
    
    @State var profileName: String = ""
    
    var body: some View {
        HStack(spacing: 10) {
            Button(action: {
                showSaveAlert.toggle()
            }, label: {
                VStack {
                    Image(systemName: "square.and.arrow.down")
                    Text("Save")
                        .font(.callout)
                }.padding(5)
            }).buttonStyle(.gentleFilling)
                .alert("Are you sure you want to overwrite the profile \(mixer.micProfileName) ?", isPresented: $showSaveAlert) {
                    Button("OK") {
                        GoXlr.shared.command(.SaveMicProfile)
                    }
                    Button("Cancel", role: .cancel) {}
                }
            
            Button(action: {
                showNewSheet.toggle()
            }, label: {
                VStack {
                    Image(systemName: "doc.badge.plus")
                    Text("New")
                        .font(.callout)
                }
            }).buttonStyle(.gentleFilling)
                .sheet(isPresented: $showNewSheet) {
                    TextInputAlertElement("Enter a new profile name", isPresented: $showNewSheet) { profileName in
                        GoXlr.shared.command(.NewMicProfile(profileName))
                    }
                }
            
            Button(action: {
                showDuplicateSheet.toggle()
            }, label: {
                VStack {
                    Image(systemName: "doc.on.doc")
                    Text("Duplicate")
                        .font(.callout)
                }
            }).buttonStyle(.gentleFilling)
                .sheet(isPresented: $showDuplicateSheet) {
                    TextInputAlertElement("Enter a new profile name", isPresented: $showDuplicateSheet) { profileName in
                        showDuplicateSheet.toggle()
                        GoXlr.shared.command(.SaveMicProfileAs(profileName))
                    }
                }
            
        }
    }
}

struct TextInputAlertElement: View {
    @State var prompt: String = ""
    @State var profileName: String = ""

    @Binding var isPresented: Bool
    
    var onValidate: (String) -> Void
    @State var disabled: Bool = false
    
    init(_ prompt: String, isPresented: Binding<Bool>, onValidate: @escaping (String) -> Void) {
        self.prompt = prompt
        self.profileName = ""
        self._isPresented = isPresented
        self.onValidate = onValidate
    }
    
    init(_ prompt: String, initialValue: String, isPresented: Binding<Bool>, onValidate: @escaping (String) -> Void) {
        self.prompt = prompt
        self.profileName = initialValue
        self._isPresented = isPresented
        self.onValidate = onValidate
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text(prompt)
                .font(.title3)
            TextField("", text: $profileName)
                .textFieldStyle(.roundedBorder)
                .padding()
                .padding(.vertical, 5)
            HStack {
                
                Button(action: {
                    isPresented.toggle()
                    onValidate(profileName)
                    disabled = true
                }, label: {
                    HStack {
                        Spacer()
                        Text("OK")
                        Spacer()
                    }
                }).disabled(profileName.count < 1)
                    .keyboardShortcut(.return, modifiers: [])
                
                Button(role: .cancel, action: {
                    isPresented.toggle()
                }, label: {
                    HStack {
                        Spacer()
                        Text("Cancel")
                        Spacer()
                    }
                })
                
            }
        }.controlSize(.large)
            .padding(20)
            .frame(width: 250)
            .disabled(disabled)
    }
}
