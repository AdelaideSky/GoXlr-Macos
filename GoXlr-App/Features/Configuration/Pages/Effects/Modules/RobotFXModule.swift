//
//  RobotFXModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 23/04/2023.
//

import SwiftUI
import GoXlrKit

struct RobotFXModule: View {
    @ObservedObject var current = GoXlr.shared.mixer!.effects!.current
    
    @State var showDetails: Bool = false
    
    @FocusState var amountFocused: Bool
    
    var body: some View {
        Section("Robot") {
            Picker("Style", selection: $current.robot.style) {
                Text("Robot 1").tag(RobotStyle.Robot1)
                Text("Robot 2").tag(RobotStyle.Robot2)
                Text("Robot 3").tag(RobotStyle.Robot3)
            }
            DisclosureGroup("Advanced...", isExpanded: $showDetails) {
                HStack {
                    Spacer()
                    Group {
                        LabelledVSliderElement(label: "Low gain", value: $current.robot.lowGain, range: -12...12, unity: "dB")
                        LabelledVSliderElement(label: "Low freq", value: $current.robot.lowFreq, range: 20...254, unity: "Hz")
                        LabelledVSliderElement(label: "Low width", value: $current.robot.lowWidth, range: 0...32, formatValue: { value in
                            return "\(round(100 * (value / 32 * 10)) / 100)"
                        })
                        LabelledVSliderElement(label: "Mid gain", value: $current.robot.midGain, range: -12...12, unity: "dB")
                        LabelledVSliderElement(label: "Mid freq", value: $current.robot.midFreq, range: 20...254, unity: "Hz")
                        LabelledVSliderElement(label: "Mid width", value: $current.robot.midWidth, range: 0...32, formatValue: { value in
                            return "\(round(100 * (value / 32 * 10)) / 100)"
                        })
                        LabelledVSliderElement(label: "Hi gain", value: $current.robot.highGain, range: -12...12, unity: "dB")
                        LabelledVSliderElement(label: "Hi freq", value: $current.robot.highFreq, range: 20...254, unity: "Hz")
                        LabelledVSliderElement(label: "Hi width", value: $current.robot.highWidth, range: 0...32, formatValue: { value in
                            return "\(round(100 * (value / 32 * 10)) / 100)"
                        })
                    }.frame(width: 63)
                    Spacer()
                }.frame(height: 300)
            }
            if showDetails {
                HStack(alignment: .center) {
                    Text("Waveform")
                    Spacer()
                    Slider(value: $current.robot.waveform, in: 0...2).controlSize(.small)
                    Divider()
                    Text(current.robot.waveform.roundedString)
                        .frame(width: 40)
                        .foregroundColor(.secondary)
                }
                HStack(alignment: .center) {
                    Text("Pulse width")
                    Spacer()
                    Slider(value: $current.robot.pulseWidth, in: 0...100).controlSize(.small)
                    Divider()
                    Text(current.robot.pulseWidth.roundedString + "%")
                        .frame(width: 40)
                        .foregroundColor(.secondary)
                }
                HStack(alignment: .center) {
                    Text("Threshold")
                    Spacer()
                    Slider(value: $current.robot.threshold, in: -36...0).controlSize(.small)
                    Divider()
                    Text(current.robot.threshold.roundedString + "dB")
                        .frame(width: 40)
                        .foregroundColor(.secondary)
                }
                HStack(alignment: .center) {
                    Text("Dry Mix")
                    Spacer()
                    Slider(value: $current.robot.dryMix, in: -36...0).controlSize(.small)
                    Divider()
                    Text(current.robot.dryMix.roundedString + "dB")
                        .frame(width: 40)
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}
