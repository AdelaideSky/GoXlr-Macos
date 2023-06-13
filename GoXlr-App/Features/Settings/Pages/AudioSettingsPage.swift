//
//  AudioSettingsPage.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 05/05/2023.
//

import SwiftUI
import GoXlrKit
import GoXlrKit_Audio

struct AudioSettingsPage: View {
    @ObservedObject var goxlr = GoXlr.shared
    @ObservedObject var appSettings = AppSettings.shared
    @ObservedObject var goxlrAudio = GoXlrAudio.shared
    
    @State var selectedAggregate: Set<ManagedAggregate.ID> = []
    @State private var sortOrder = [KeyPathComparator(\ManagedAggregate.name)]
    
    @State var showingDeleteAggregatesAlert: Bool = false
    
    var body: some View {
        Form {
            Section("Managed devices") {
                Table(goxlrAudio.managedAggregates.sorted(using: sortOrder), selection: $selectedAggregate, sortOrder: $sortOrder) {
                    TableColumn("Name", value: \.name)
                    TableColumn("Scope", value: \.scope.rawValue)
                    TableColumn("Device model", value: \.deviceModel.rawValue)
                }.onDeleteCommand {
                    showingDeleteAggregatesAlert.toggle()
                }
                .padding(.bottom, 27)
                .overlay(alignment: .bottom, content: {
                    VStack(alignment: .leading, spacing: 0) {
                        Divider()
                        Spacer()
                        HStack(spacing: 5) {
                            Button(action: {}) {
                                ZStack {
                                    Rectangle()
                                        .fill(.white.opacity(0.001))
                                    Image(systemName: "plus")
                                }.fixedSize()
                            }.buttonStyle(.plain)
                            Button(action: {
                                showingDeleteAggregatesAlert.toggle()
                            }) {
                                ZStack {
                                    Rectangle()
                                        .fill(.white.opacity(0.001))
                                    Image(systemName: "minus")
                                }.fixedSize()
                            }.buttonStyle(.plain)
                                .disabled(selectedAggregate.isEmpty ? true : false)
                        }.padding(.leading, 10)
                        .buttonStyle(.borderless)
                        Spacer()
                    }.frame(height: 27)
                    .background(Rectangle().opacity(0.04))
                })
                .alert("Are you sure you wanna delete \(selectedAggregate.count > 1 ? "the \(selectedAggregate.count) aggregates" : "this aggregate") ?", isPresented: $showingDeleteAggregatesAlert) {
                    Button("Yes", role: .destructive) {
                        for aggregate in selectedAggregate {
                            if let device = goxlrAudio.managedAggregates.first(where: {$0.id == aggregate}) {
                                device.delete()
                                goxlrAudio.managedAggregates.remove(device)
                            }
                        }
                        selectedAggregate.removeAll()
                    }
                    Button("No", role: .cancel) { showingDeleteAggregatesAlert = false }
                }
            }
            Section("Setup") {
                HStack {
                    Text("Create audio devices for...")
                    Spacer()
                    Menu(goxlr.device, content: {
                        ForEach(goxlr.status!.data.status.mixers.sorted(), id:\.key) { mixer in
                            Button("\(mixer.0) (\(mixer.1.hardware.deviceType.rawValue))") {
                                switch mixer.1.hardware.deviceType {
                                case .Full:
                                    goxlrAudio.setUp.createAggregates(.Full, serial: mixer.0)
                                case .Mini:
                                    goxlrAudio.setUp.createAggregates(.Mini, serial: mixer.0)
                                }
                                
                            }
                        }
                    }, primaryAction: {
                        switch goxlr.mixer!.hardware.deviceType {
                        case .Full:
                            goxlrAudio.setUp.createAggregates(.Full, serial: GoXlr.shared.device)
                        case .Mini:
                            goxlrAudio.setUp.createAggregates(.Mini, serial: GoXlr.shared.device)
                        }
                    }).menuStyle(.borderlessButton)
                        .overlay(
                                RoundedRectangle(cornerRadius: 5)
                                    .stroke(.secondary)
                                    .opacity(0.7)
                            )
                        .fixedSize()
                }
            }
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
    }
}
