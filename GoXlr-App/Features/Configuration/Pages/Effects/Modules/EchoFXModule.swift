//
//  EchoFXModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 22/04/2023.
//

import SwiftUI
import GoXlrKit

struct EchoFXModule: View {
    @ObservedObject var current = GoXlr.shared.mixer!.effects!.current
    
    @State var showDetails: Bool = false
    
    @FocusState var amountFocused: Bool
    
    var body: some View {
        Section("Echo") {
            Picker("Style", selection: $current.echo.style) {
                Text("Quarter").tag(EchoStyle.Quarter)
                Text("Eighth").tag(EchoStyle.Eighth)
                Text("Triplet").tag(EchoStyle.Triplet)
                Text("Ping Pong").tag(EchoStyle.PingPong)
                Text("Classic Slap").tag(EchoStyle.ClassicSlap)
                Text("MultiTap").tag(EchoStyle.MultiTap)
            }
            HStack(alignment: .center) {
                Text("Amount")
                Spacer()
                Slider(value: $current.echo.amount, in: 0...100).controlSize(.small)
                Divider()
                TextField(value: $current.echo.amount, format: .rounded, label: {})
                    .textFieldStyle(.plain)
                    .font(.system(.body))
                    .foregroundColor(.secondary)
                    .frame(width: 25)
                    .offset(y: -2.5)
                    .focused($amountFocused)
                    .onSubmit {
                        amountFocused.toggle()
                    }
            }
            DisclosureGroup("Advanced...", isExpanded: $showDetails) {
                HStack {
                    Spacer()
                    Group {
                        LabelledVSliderElement(label: "Feedback", value: $current.echo.feedback, range: 0...100, unity: "%")
                        LabelledVSliderElement(label: "Tempo", value: $current.echo.tempo, range: 45...300, unity: "BPM")
                        if current.echo.style == .ClassicSlap {
                            LabelledVSliderElement(label: "Delay L", value: $current.echo.delayLeft, range: 0...2500, unity: "ms")
                            LabelledVSliderElement(label: "Delay R", value: $current.echo.delayRight, range: 0...2500, unity: "ms")
                        }
                        LabelledVSliderElement(label: "Feedback L", value: $current.echo.feedbackLeft, range: 0...100, unity: "%")
                        LabelledVSliderElement(label: "XFB L to R", value: $current.echo.feedbackXfbLToR, range: 0...100, unity: "%")
                        LabelledVSliderElement(label: "Feedback R", value: $current.echo.feedbackRight, range: 0...100, unity: "%")
                        LabelledVSliderElement(label: "XFB R to L", value: $current.echo.feedbackXfbRToL, range: 0...100, unity: "%")
                    }.frame(width: 72)
                    Spacer()
                }.frame(height: 300)
            }
        }
    }
}
