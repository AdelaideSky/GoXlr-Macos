//
//  RouterView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 23/04/2023.
//

import SwiftUI
import GoXlrKit

struct RouterView: View {
    @ObservedObject var router = GoXlr.shared.mixer!.router
    
    var body: some View {
        Group {
            Form {
                Section {
                    HStack {
                        Spacer()
                            .frame(width: 135)
                        Group {
                            Text("Microphone")
                            Text("Chat")
                            Text("Music")
                            Text("Game")
                            Text("Console")
                            Text("Line-In")
                            Text("System")
                            Text("Sample")
                        }.frame(maxWidth: .infinity)
                    }
                }
            }.frame(height: 60)
            HStack {
                Form {
                    Section() {
                        Text("Headphones")
                        Text("Broadcast Mix")
                        Text("Line-Out")
                        Text("Chat Mic")
                    }
                    Section {
                        Text("Samples")
                    }
                }.frame(width: 150)
                    .padding(.trailing, -25)
                Form {
                    Section() {
                        HStack {
                            ForEach((0...7), id: \.self) { index in
                                Toggle("", isOn: router.everyHeadphones[index])
                                    .toggleStyle(CheckboxStyle())
                            }.frame(maxWidth: .infinity)
                        }
                        
                        HStack {
                            ForEach((0...7), id: \.self) { index in
                                Toggle("", isOn: router.everyBroadcastMix[index])
                                    .toggleStyle(CheckboxStyle())
                            }.frame(maxWidth: .infinity)
                        }
                        
                        HStack {
                            ForEach((0...7), id: \.self) { index in
                                Toggle("", isOn: router.everyLineOut[index])
                                    .toggleStyle(CheckboxStyle())
                            }.frame(maxWidth: .infinity)
                        }
                        
                        HStack {
                            ForEach((0...7), id: \.self) { index in
                                Toggle("", isOn: router.everyChatMic[index])
                                    .toggleStyle(CheckboxStyle())
                                    .disabled(index == 1)
                            }.frame(maxWidth: .infinity)
                        }
                    }
                    Section {
                        HStack {
                            ForEach((0...7), id: \.self) { index in
                                Toggle("", isOn: router.everySampler[index])
                                    .toggleStyle(CheckboxStyle())
                                    .disabled(index == 7)
                            }.frame(maxWidth: .infinity)
                        }
                    }
                }
            }.padding(.top, -20)
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
    }
}
