//
//  RoutingMmodSettingsPage.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 26/04/2023.
//

import SwiftUI
import GoXlrKit

struct RoutingMmodSettingsPage: View {
    @ObservedObject var configuration = AppSettings.shared.mmodsSettings.routing
    var body: some View {
        Form {
            Section("Route 1") {
                Picker("Input", selection: $configuration.route1.input) {
                    ForEach(InputDevice.allCases, id:\.rawValue) { input in
                        Text(input.rawValue).tag(input as InputDevice?)
                    }
                }
                Picker("Output", selection: $configuration.route1.output) {
                    ForEach(OutputDevice.allCases, id:\.rawValue) { output in
                        Text(output.rawValue).tag(output as OutputDevice?)
                    }
                }
            }
            Section("Route 2") {
                Picker("Input", selection: $configuration.route2.input) {
                    ForEach(InputDevice.allCases, id:\.rawValue) { input in
                        Text(input.rawValue).tag(input as InputDevice?)
                    }
                    Text("None").tag(nil as InputDevice?)
                }
                Picker("Output", selection: $configuration.route2.output) {
                    ForEach(OutputDevice.allCases, id:\.rawValue) { output in
                        Text(output.rawValue).tag(output as OutputDevice?)
                    }
                    Text("None").tag(nil as OutputDevice?)
                }.disabled(configuration.route2.input == nil)
            }
            if configuration.route2.output != nil {
                Section("Route 3") {
                    Picker("Input", selection: $configuration.route3.input) {
                        ForEach(InputDevice.allCases, id:\.rawValue) { input in
                            Text(input.rawValue).tag(input as InputDevice?)
                        }
                        Text("None").tag(nil as InputDevice?)
                    }
                    Picker("Output", selection: $configuration.route3.output) {
                        ForEach(OutputDevice.allCases, id:\.rawValue) { output in
                            Text(output.rawValue).tag(output as OutputDevice?)
                        }
                        Text("None").tag(nil as OutputDevice?)
                    }.disabled(configuration.route3.input == nil)
                }
            }
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
    }
}
