//
//  GateMicModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 20/04/2023.
//

import SwiftUI
import GoXlrKit

struct GateMicModule: View {
    
    @State var showDetail: Bool = false
    @ObservedObject var noiseGate = GoXlr.shared.mixer!.micStatus.noiseGate
    
    @FocusState var amountFocused: Bool
    
    var body: some View {
        Section(content: {
            if !showDetail {
                HStack(alignment: .center) {
                    Text("Amount")
                    Spacer()
                    Slider(value: $noiseGate.threshold, in: -59...0).controlSize(.small)
                    Divider()
                    TextField(value: $noiseGate.threshold, format: .thresholdStyle(), label: {})
                        .textFieldStyle(.plain)
                        .font(.system(.body))
                        .foregroundColor(.secondary)
                        .frame(maxWidth: 25)
                        .offset(y: -2.5)
                        .focused($amountFocused)
                        .onSubmit {
                            amountFocused.toggle()
                        }
                }
            } else {
                HStack(alignment: .center) {
                }.frame(height: 300)
            }
        }, header: {
            HStack {
                Text("Gate")
                    .font(.headline)
                Spacer()
                Toggle("Advanced", isOn: $showDetail)
                    .toggleStyle(.switch)
                    .controlSize(.mini)
            }
        })
    }
}
