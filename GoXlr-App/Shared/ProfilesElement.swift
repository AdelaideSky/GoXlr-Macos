//
//  ProfilesElement.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 23/04/2023.
//

import SwiftUI
import GoXlrKit

struct ProfilesElement: View {
    @ObservedObject var files = GoXlr.shared.status!.data.status.files
    @ObservedObject var mixer = GoXlr.shared.mixer!
    
    @State var showDeleteAlert: Bool = false
    
    var body: some View {
        Section(content: {
            VStack {
                List(files.profiles.prefix(files.profiles.count == 6 ? 6 : 5), id:\.self, selection: $mixer.profileName) { profile in
                    ProfileRowElement(profile)
                        .tag(profile)
                }.listStyle(.inset)
                    .padding(.bottom, files.profiles.count > 6 ? -13 : 0)
                if files.profiles.count > 6 {
                    DisclosureGroup("More...") {
                        List(files.profiles.dropFirst(5), id:\.self, selection: $mixer.profileName) { profile in
                            ProfileRowElement(profile)
                                .tag(profile)
                        }.listStyle(.inset)
                            .padding(.horizontal, -10)
                    }.padding(.horizontal, 10)
                }
            }
                
        }, header: {
            HStack {
                Text("Profiles")
                Spacer()
                Button(action: {
                    URL(fileURLWithPath: GoXlr.shared.status!.data.status.paths.profileDirectory).showInFinder()
                }, label: {
                    Image(systemName: "folder.fill")
                }).buttonStyle(.borderless)
            }
        })
        Section {
            ProfileActionsRowElement()
        }
    }
}
struct ProfileRowElement: View {
    
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
                    if profile != GoXlr.shared.mixer!.profileName {
                        GoXlr.shared.mixer!.profileName = profile
                    } else {
                        showLoadActiveAlert = true
                    }
                }
                Button("Delete profile") {
                    showDeleteAlert = true
                }.disabled(GoXlr.shared.status!.data.status.files.profiles.count <= 1)
            }, label: {
                Image(systemName: "ellipsis")
                    .font(.headline)
            }).menuStyle(.borderlessButton)
                .menuIndicator(.hidden)
                .frame(width: 20)
        }.alert("Are you sure you want to delete the profile \(profile)", isPresented: $showDeleteAlert) {
            
            Button("Cancel", role: .cancel) {}
            Button("Delete", role: .destructive) {
                if GoXlr.shared.mixer!.profileName == profile {
                    GoXlr.shared.mixer!.profileName = GoXlr.shared.status!.data.status.files.profiles.first!
                }
                GoXlr.shared.command(.DeleteProfile(profile))
            }
        }
        .alert("Are you sure you want to reload the profile \(profile)", isPresented: $showLoadActiveAlert, actions: {
            
            Button("Cancel", role: .cancel) {}
            Button("Reload", role: .destructive) {
                GoXlr.shared.command(.LoadProfile(profile, true))
            }
        }, message: {
            Text("You will loose all modifications.")
        })
    }
}
struct ProfileActionsRowElement: View {
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
                .alert("Are you sure you want to overwrite the profile \(mixer.profileName) ?", isPresented: $showSaveAlert) {
                    Button("OK") {
                        GoXlr.shared.command(.SaveProfile)
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
                        GoXlr.shared.command(.NewProfile(profileName))
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
                        GoXlr.shared.command(.SaveProfileAs(profileName))
                    }
                }
            
        }
    }
}
