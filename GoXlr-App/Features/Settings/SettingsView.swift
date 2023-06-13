//
//  SettingsView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 18/04/2023.
//

import SwiftUI
import GoXlrKit

extension [String: Mixer] {
    func sorted() -> [Dictionary<String, Mixer>.Element] {
        return self.sorted(by: {$0.0 < $1.0})
    }
}

struct SettingsView: View {
    @ObservedObject var status = GoXlr.shared.status!.data.status
    
    @State private var searchText: String = ""
    @Environment(\.presentationMode) var presentationMode

    var pages: [SettingsPage] = [
        .init(.general, baseColor: .gray, icon: .system("gear")),
        .init(.menubar, baseColor: .indigo, icon: .system("menubar.rectangle")),
        .init(.audio, baseColor: .pink, icon: .system("speaker.wave.3.fill")),
        .init(.behaviors, baseColor: .red, icon: .system("flowchart")),
        .init(.extensions, baseColor: .blue, icon: .system("puzzlepiece.fill"))
    ]
    
    @State var selection: SettingsPage = .init(.general, baseColor: .gray, icon: .system("gear"))
    
    var body: some View {
        NavigationSplitView(sidebar: {
            List(selection: $selection) {
                Section("Settings") {
                    ForEach(pages) { item in
                        if let name = item.name {
                            if searchText.isEmpty || name.rawValue.lowercased().contains(searchText.lowercased()) {
                                SettingsRowView(item).tag(item)
                            }
                        }
                    }
                }
                Section("Devices") {
                    ForEach(status.mixers.sorted(), id: \.key) { mixer in
                        SettingsRowView(.init(mixer.key, deviceType: mixer.value.hardware.deviceType))
                    }
                }
            }.navigationSplitViewColumnWidth(215)
        }, detail: {
            Group {
                if let name = selection.name {
                    switch name {
                    case .general:
                        GeneralSettingsPage()
                    case .menubar:
                        MenubarSettingsPage()
                    case .audio:
                        AudioSettingsPage()
                    case .behaviors:
                        BehavioursSettingsPage()
                    default:
                        EmptyView()
                    }
                } else if let deviceUID = selection.deviceUID, let deviceModel = selection.deviceModel {
                    MixerSettingsPage(deviceUID, model: deviceModel)
                }
            }.removeSettingsStyling()
                .clipped()
                .navigationTitle(selection.nameString)
        }).navigationSplitViewStyle(.balanced)
//            .searchable(text: $searchText, placement: .sidebar, prompt: "Search")
            
    }
}

struct SettingsRowView: View {
    var page: SettingsPage

    init(_ page: SettingsPage) {
        self.page = page
    }

    var body: some View {
        NavigationLink(value: page) {
            Label {
                Text(page.nameString)
                    .padding(.leading, 2)
            } icon: {
                if let icon = page.icon {
                    Group {
                        switch icon {
                        case .system(let name):
                            Image(systemName: name)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .symbol(let name):
                            Image(name)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        case .asset(let name):
                            Image(name)
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                        }
                    }
                    .padding(2.5)
                    .foregroundColor(.white)
                    .frame(width: 20, height: 20)
                    .background {
                        RoundedRectangle(
                            cornerRadius: 5,
                            style: .continuous
                        )
                        .fill(page.baseColor.gradient)
                    }
                } else {
                    EmptyView()
                }
            }
        }
    }
}
