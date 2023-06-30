//
//  CommandsEditableListView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 15/06/2023.
//

import SwiftUI
import GoXlrKit

struct CommandsEditableListView: View {
    @State var selection: Int? = nil
    
    var title: String
    var emptyLabel: String
    @Binding var list: [GoXLRCommand]
    var limit: Int
    var prioritiseSaves: Bool
    
    public init(_ title: String, emptyLabel: String, list: Binding<[GoXLRCommand]>, limit: Int = 10, prioritiseSaves: Bool = true) {
        self.title = title
        self.emptyLabel = emptyLabel
        self._list = list
        self.limit = limit
        self.prioritiseSaves = prioritiseSaves
    }
    
    var body: some View {
        Section(title) {
            List(selection: $selection) {
                if list.isEmpty {
                    Text(emptyLabel)
                        .font(.caption)
                        .foregroundStyle(.secondary)
                        .multilineTextAlignment(.center)
                        .padding()
                        .padding(.horizontal)
                } else {
                    ForEach(0...(list.count-1), id:\.self) { id in
                        HStack {
                            switch list[id] {
                            case .LoadProfileColours(let profile):
                                Text("Load Profile Colour")
                                Spacer()
                                Picker("", selection: Binding(get: { profile }, set: { list[id] = .LoadProfileColours($0) })) {
                                    ForEach(GoXlr.shared.status!.data.status.files.profiles, id:\.self) { profile in
                                        Text(profile).id(profile)
                                    }
                                }.fixedSize()
                                
                            case .LoadProfile(let profile, let bool):
                                Text("Load Profile")
                                Spacer()
                                Picker("", selection: Binding(get: { profile }, set: { list[id] = .LoadProfile($0, bool) })) {
                                    ForEach(GoXlr.shared.status!.data.status.files.profiles, id:\.self) { profile in
                                        Text(profile).tag(profile)
                                    }
                                }.fixedSize()
                                
                            case .SaveProfile:
                                Text("Save Profile")
                                
                            case .SaveMicProfile:
                                Text("Save Mic Profile")
                                
                            case .SetVolume(let channel, let volume):
                                if volume == 0 {
                                    Text("Mute Channel")
                                    Spacer()
                                    Picker("", selection: Binding(get: { channel }, set: { list[id] = .SetVolume($0, 0) })) {
                                        ForEach(ChannelName.allCases, id:\.rawValue) { channel in
                                            Text(channel.displayName).tag(channel)
                                        }
                                    }.fixedSize()
                                }
                                
                            default:
                                EmptyView()
                            }
                        }.padding(.vertical, 4)
                            .moveDisabled(list[id] == .SaveProfile || list[id] == .SaveMicProfile)
                            .tag(id)
                    }.onMove { from, to in
                        list.move(fromOffsets: from, toOffset: to)
                    }
                    .onDelete() { index in
                        list.remove(atOffsets: index)
                    }
                }
            }.padding(.bottom, 24)
                .overlay(alignment: .bottom, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        Divider()
                        Spacer()
                        HStack(spacing: 5) {
                            Menu(content: {
                                Button("Load Profile Color") {
                                    list.append(.LoadProfileColours(GoXlr.shared.status?.data.status.files.profiles.first ?? ""))
                                }
                                Button("Load Profile") {
                                    list.append(.LoadProfile(GoXlr.shared.status?.data.status.files.profiles.first ?? "", true))
                                }
                                Button("Save Profile") {
                                    if prioritiseSaves {
                                        list.insert(.SaveProfile, at: 0)
                                    } else {
                                        list.append(.SaveProfile)
                                    }
                                }
                                Button("Save Mic Profile") {
                                    if prioritiseSaves {
                                        list.insert(.SaveMicProfile, at: 0)
                                    } else {
                                        list.append(.SaveMicProfile)
                                    }
                                }
                                Button("Mute Channel") {
                                    list.append(.SetVolume(.System, 0))
                                }
                            }, label: {
                                ZStack {
                                    Rectangle()
                                        .fill(.white.opacity(0.001))
                                    Image(systemName: "plus")
                                }
                            }).fixedSize()
                                .buttonStyle(.plain)
                                .disabled(list.count >= 10)
                            Button(action: {
                                list.remove(at: selection!)
                                selection = nil
                            }) {
                                ZStack {
                                    Rectangle()
                                        .fill(.white.opacity(0.001))
                                    Image(systemName: "minus")
                                }.fixedSize()
                            }.buttonStyle(.plain)
                                .disabled(selection == nil ? true : false)
                        }.padding(.leading, 10)
                            .buttonStyle(.borderless)
                        Spacer()
                    }.frame(height: 27)
                        .background(Rectangle().opacity(0.04))
                })
        }
    }
}

