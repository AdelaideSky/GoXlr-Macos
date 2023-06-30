//
//  ButtonPressBehaviours.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 15/06/2023.
//

import SwiftUI
import GoXlrKit

struct ButtonPressBehaviours: View {
    @ObservedObject var settings = AppSettings.shared
    @State var selection: String? = nil
    @State var shortcuts: [String]? = nil
    
    var buttons: [String] = ["Fader1Mute", "Fader2Mute", "Fader3Mute", "Fader4Mute", "Bleep", "Cough", "EffectSelect1", "EffectSelect2", "EffectSelect3", "EffectSelect4", "EffectSelect5", "EffectSelect6", "EffectFx", "EffectMegaphone", "EffectRobot", "EffectHardTune", "SamplerSelectA", "SamplerSelectB", "SamplerSelectC", "SamplerTopLeft", "SamplerTopRight", "SamplerBottomLeft", "SamplerBottomRight", "SamplerClear"]
    
    var body: some View {
        Section("On Button Press (Shortcuts)") {
            if let shortcuts = shortcuts {
                List(selection: $selection) {
                    if settings.observationStore.isEmpty {
                        Text("Click the plus icon to set a shortcut that will run when the selected button is pressed !")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                            .multilineTextAlignment(.center)
                            .padding()
                            .padding(.horizontal)
                    } else {
                        ForEach(settings.observationStore.sorted(using: KeyPathComparator(\.key)), id:\.key) { element in
                            HStack {
                                Picker("Button", selection: Binding(get: {element.key}, set: {settings.observationStore.changeKey(from: element.key, to: $0)})) {
                                    Text("Select").tag("Select" as String?)
                                    ForEach(buttons, id:\.self) { button in
                                        
                                        Text(button).tag(button as String?)
                                    }
                                }.labelsHidden()
                                    .fixedSize()
                                Spacer()
                                Picker("Shortcut", selection: settings.$observationStore[element.key]) {
                                    Text("Select").tag("Select" as String?)
                                    ForEach(shortcuts, id:\.self) { shortcut in
                                        Text(shortcut).tag(shortcut as String?)
                                    }
                                }.labelsHidden()
                                    .fixedSize()
                            }.padding(.vertical, 4)
                        }
                    }
                }.padding(.bottom, 24)
                    .overlay(alignment: .bottom, content: {
                        VStack(alignment: .leading, spacing: 0) {
                            Divider()
                            Spacer()
                            HStack(spacing: 5) {
                                Button(action: {
                                    settings.observationStore["Select"] = "Select"
                                }) {
                                    ZStack {
                                        Rectangle()
                                            .fill(.white.opacity(0.001))
                                        Image(systemName: "plus")
                                    }.fixedSize()
                                }.buttonStyle(.plain)
                                Button(action: {
                                    settings.observationStore[selection!] = nil
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
            } else {
                HStack {
                    Spacer()
                    LoadingElement()
                    Spacer()
                }
            }
        }
        .task {
            shortcuts = Shortcuts().get()
        }
        .animation(.easeInOut, value: shortcuts)
    }
}
