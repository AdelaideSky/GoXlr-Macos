//
//  FXView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 22/04/2023.
//

import SwiftUI
import GoXlrKit

struct FXView: View {
    @ObservedObject var effects = GoXlr.shared.mixer!.effects!
    @ObservedObject var files = GoXlr.shared.status!.data.status.files
    var body: some View {
        NavigationStack {
            Form {
                Section(content: {
                    List {
                        ForEach(files.presets, id:\.self) { preset in
                            Text(preset.replacingOccurrences(of: "_", with: " "))
                                .draggable(preset)
                        }
                    }.listStyle(.automatic)
                }, header: {
                    HStack {
                        Text("Library")
                        Spacer()
                        Button(action: {
                            URL(fileURLWithPath: GoXlr.shared.status!.data.status.paths.presetsDirectory).showInFinder()
                        }, label: {
                            Image(systemName: "folder.fill")
                        }).buttonStyle(.borderless)
                    }
                })
                Section(content: {
                    FXPresetRowElement(.Preset1, index: 1, name: effects.presetNames.preset1)
                    FXPresetRowElement(.Preset2, index: 2, name: effects.presetNames.preset2)
                    FXPresetRowElement(.Preset3, index: 3, name: effects.presetNames.preset3)
                    FXPresetRowElement(.Preset4, index: 4, name: effects.presetNames.preset4)
                    FXPresetRowElement(.Preset5, index: 5, name: effects.presetNames.preset5)
                    FXPresetRowElement(.Preset6, index: 6, name: effects.presetNames.preset6)
                }, header: {
                    HStack {
                        Text("Presets")
                        Spacer()
                        Toggle("FX enabled", isOn: $effects.isEnabled)
                            .toggleStyle(.switch)
                            .controlSize(.mini)
                    }
                })
            }.formStyle(.grouped)
                .scrollContentBackground(.hidden)
                .frame(width: 700)
                .scrollIndicators(.hidden)
        }.clipped()
    }
}

struct FXPresetRowElement: View {
    var preset: EffectBankPresets
    var name: String
    var index: Int
    
    init(_ preset: EffectBankPresets, index: Int, name: String) {
        self.preset = preset
        self.name = name
        self.index = index
    }
    
    var body: some View {
        NavigationLink(destination: {
            FXPresetDetailElement(preset)
                .navigationTitle("\(index): \(name)")
                .onAppear {
                    GoXlr.shared.command(.SetActiveEffectPreset(preset))
                }
        }, label: {
            HStack {
                Image(systemName: "\(index).square.fill")
                    .font(.title2)
                Divider()
                Text(name)
            }
        }).dropDestination(for: String.self) { presetName, _ in
            guard presetName.first! != name else { return false }
            GoXlr.shared.command(.SetActiveEffectPreset(preset))
            GoXlr.shared.command(.LoadEffectPreset(presetName.first!))
            return true
        }
    }
}

struct FXPresetDetailElement: View {
    var preset: EffectBankPresets
    
    init(_ preset: EffectBankPresets) {
        self.preset = preset
    }
    
    var body: some View {
        Form {
            ReverbFXModule()
            EchoFXModule()
            GenderFXModule()
            MegaphoneFXModule()
            Section("Robot") {Text("TODO")}
            Section("Hard Tune") {Text("TODO")}
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .frame(width: 700)
            .scrollIndicators(.hidden)
            .clipped()
    }
}
