//
//  SamplerView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 28/05/2023.
//

import SwiftUI
import GoXlrKit

struct SamplerView: View {
    @ObservedObject var router = GoXlr.shared.mixer!.router
    
    var body: some View {
        Form {
            Section {
                DisclosureGroup("Bank A") {
                    HStack {
                        Section() {
                            VStack {
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                            }
                        }
                        Section() {
                            VStack {
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                            }
                        }
                    }
                }
            }
            Section {
                DisclosureGroup("Bank B") {
                    HStack {
                        Section() {
                            VStack {
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                            }
                        }
                        Section() {
                            VStack {
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                            }
                        }
                    }
                }
            }
            Section {
                DisclosureGroup("Bank C") {
                    HStack {
                        Section() {
                            VStack {
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                            }
                        }
                        Section() {
                            VStack {
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                                Button("Top left") {}
                                    .buttonStyle(.gentleFilling)
                            }
                        }
                    }
                }
            }
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
            .scrollDisabled(true)
    }
}
