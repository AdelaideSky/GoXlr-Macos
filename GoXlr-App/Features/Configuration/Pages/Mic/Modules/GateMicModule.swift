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
        Section("Gate") {
            DisclosureGroup("Advanced...", isExpanded: $showDetail) {
                HStack {
                    Spacer()
                    Group {
                        LabelledVSliderElement(label: "Threshold", value: $noiseGate.threshold, range: -59...0, unity: "dB")
                        LabelledVSliderElement(label: "Attenuation", value: $noiseGate.attenuation, range: 0...100, unity: "%")
                        LabelledVSliderElement(label: "Attack", value: $noiseGate.attack, range: 0...44, formatValue: { value in
                            return GateTimes(rawValue: Int(value))!.float.roundedString + "ms"
                        })
                        LabelledVSliderElement(label: "Release", value: $noiseGate.release, range: 0...44, formatValue: { value in
                            return GateTimes(rawValue: Int(value))!.float.roundedString + "ms"
                        })
                    }.frame(width: 80)
                    Spacer()
                }.frame(height: 300)
            }
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
