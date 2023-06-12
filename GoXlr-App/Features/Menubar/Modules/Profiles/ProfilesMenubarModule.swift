//
//  ProfilesMenubarModule.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 26/04/2023.
//

import SwiftUI
import GoXlrKit

struct ProfilesMenubarModule: View {
    @ObservedObject var status = GoXlr.shared.status!.data.status
    @ObservedObject var mixer = GoXlr.shared.mixer!
    var body: some View {
        VStack(alignment: .center, spacing: 3) {
            HStack {
                
                Menu(mixer.micProfileName) {
                    ForEach(status.files.micProfiles, id: \.self) { profile in
                        Button(profile) {
                            GoXlr.shared.command(.LoadMicProfile(profile))
                        }
                    }
                }
                
                Button {
                    GoXlr.shared.command(.SaveMicProfile)
                } label: {
                    Text("Save Mic Profile")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                }.keyboardShortcut("s", modifiers: [.command, .option])
            }.labelStyle(.iconOnly)
            .controlSize(.large)
            .padding(.bottom, 5)

            HStack {
                
                Toggle(isOn: !$mixer.router.microphone.headphones) {
                    ZStack {
                        Label("Mute mic monitor", systemImage: "mic.and.signal.meter.fill")
                        if !mixer.router.microphone.headphones {
                            Image(systemName: "line.diagonal")
                                .scaleEffect(1.7)
                        }
                    }

                }.toggleStyle(.button)
                
                Button {
                    GoXlr.shared.command(.SaveProfile)
                } label: {
                    Text("Save Profile")
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.primary)
                }.keyboardShortcut("s")
                
                Menu(mixer.profileName) {
                    ForEach(status.files.profiles, id: \.self) { profile in
                        Button(profile) {
                            GoXlr.shared.command(.LoadProfile(profile))
                        }
                    }
                }
                

            }.labelStyle(.iconOnly)
            .controlSize(.large)
            .padding(.top, 5)
            
        }.padding(.horizontal, 10)
            .frame(width: 270)
            .padding(.vertical, 10)
    }
}
