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
    
    @State var showingRenameAlert: Bool = false
    
    init(_ preset: EffectBankPresets, index: Int, name: String) {
        self.preset = preset
        self.name = name
        self.index = index
    }
    
    var body: some View {
        NavigationLink(destination: {
            FXPresetDetailElement(preset)
                .navigationTitle("")
                .toolbar {
                    ToolbarItem(placement: .navigation) {
                        HStack {
                            Image(systemName: "\(index).square.fill")
                                .font(.title3)
                            Text(name)
                                .font(.title3)
                                .foregroundColor(.primary)
                                .bold()
                            Button(action: {
                                showingRenameAlert.toggle()
                                print(showingRenameAlert)
                            }, label: {
                                Label("Rename", systemImage: "square.and.pencil")
                                    .font(.title3)
                                    .labelStyle(.iconOnly)
                            }).buttonStyle(.gentle)
                                .opacity(0.5)
                                .offset(y: -1)
                        }
                    }
                }
                .sheet(isPresented: $showingRenameAlert) {
                    TextInputAlertElement("Rename this preset", initialValue: name, isPresented: $showingRenameAlert) { newPresetName in
                        GoXlr.shared.command(.RenameActivePreset(newPresetName))
                    }
                }
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
    
    @State var showSaveAlert: Bool = false
    
    init(_ preset: EffectBankPresets) {
        self.preset = preset
    }
    
    var body: some View {
        Form {
            ReverbFXModule()
            EchoFXModule()
            GenderFXModule()
            MegaphoneFXModule()
            RobotFXModule()
            HardTuneFXModule()
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .frame(width: 700)
            .scrollIndicators(.hidden)
            .clipped()
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button("Save to Library") {
                        showSaveAlert = true
                    }
                }
//                ToolbarItem(placement: .navigation) {
//                    Button("Rename") {
//                        print("UwU")
//                    }
//                }
            }
            .alert("Are you sure you want to save this configuration to Library ?", isPresented: $showSaveAlert) {
                Button("Yes") { GoXlr.shared.command(.SaveActivePreset) }
                Button("Cancel", role: .cancel) {}
            }
    }
}
