//
//  CompressorMicModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 21/04/2023.
//

import SwiftUI
import GoXlrKit

struct CompressorMicModule: View {
    @State var showDetail: Bool = false
    @ObservedObject var compressor = GoXlr.shared.mixer!.micStatus.compressor
    @FocusState var amountFocused: Bool
    
    var simplifiedAmount: Binding<Float> = .init(
        get: {
            let compressor = GoXlr.shared.mixer!.micStatus.compressor
            return ( ( compressor.makeupGain / 24 * 100 ) + compressor.threshold / -40 * 100 ) / 2
        },
        set: { newValue in
            GoXlr.shared.mixer!.micStatus.compressor.threshold = -40 + (newValue/100*40)
            GoXlr.shared.mixer!.micStatus.compressor.makeupGain = newValue/100*24
        }
    )
    
    var body: some View {
        Section("Compressor") {
            DisclosureGroup("Advanced...", isExpanded: $showDetail) {
                HStack {
                    Spacer()
                    Group {
                        LabelledVSliderElement(label: "Threshold", value: $compressor.threshold, range: -40...0)
                        LabelledVSliderElement(label: "Ratio", value: $compressor.ratio, range: 0...14, formatValue: {CompressorRatio(rawValue: Int($0))?.display ?? "error"})
                        LabelledVSliderElement(label: "Attack", value: $compressor.attack, range: 0...19)
                        LabelledVSliderElement(label: "Release", value: $compressor.release, range: 0...19)
                        LabelledVSliderElement(label: "Make-Up Gain", value: $compressor.threshold, range: 0...24)
                    }.frame(maxWidth: .infinity)
                    Spacer()
                }.frame(height: 300)
            }
            if !showDetail {
                HStack(alignment: .center) {
                    Text("Amount")
                    Spacer()
                    Slider(value: simplifiedAmount, in: 0...100).controlSize(.small)
                    Divider()
                    TextField(value: simplifiedAmount, format: .rounded, label: {})
                        .textFieldStyle(.plain)
                        .font(.system(.body))
                        .foregroundColor(.secondary)
//                        .fixedSize()
                        .frame(width: 25)
                        .offset(y: -2.5)
                        .focused($amountFocused)
                        .onSubmit {
                            amountFocused.toggle()
                        }
                }
            }
        }
    }
}

struct CompressorMicModule_Previews: PreviewProvider {
    static var previews: some View {
        CompressorMicModule()
    }
}
