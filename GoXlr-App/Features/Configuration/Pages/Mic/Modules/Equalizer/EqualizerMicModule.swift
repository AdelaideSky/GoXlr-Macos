//
//  EqualizerMicModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 21/04/2023.
//

import SwiftUI
import GoXlrKit

struct EqualizerMicModule: View {
    
    @State var showDetail: Bool = false
    @State var fineTune: Bool = false
    @ObservedObject var equalizer = GoXlr.shared.mixer!.micStatus.equaliser
    
    var simpleBass: Binding<Float> = .init(
        get: {
            var equalizer = GoXlr.shared.mixer!.micStatus.equaliser
            return (equalizer.gain["Equalizer31Hz"]! + equalizer.gain["Equalizer63Hz"]! + equalizer.gain["Equalizer125Hz"]! + equalizer.gain["Equalizer250Hz"]!)/4
        },
        set: { newValue in
            var equalizer = GoXlr.shared.mixer!.micStatus.equaliser
            equalizer.gain["Equalizer31Hz"] = newValue
            equalizer.gain["Equalizer63Hz"] = newValue
            equalizer.gain["Equalizer125Hz"] = newValue
            equalizer.gain["Equalizer250Hz"] = newValue
        }
    )
    
    var simpleMid: Binding<Float> = .init(
        get: {
            var equalizer = GoXlr.shared.mixer!.micStatus.equaliser
            return (equalizer.gain["Equalizer500Hz"]! + equalizer.gain["Equalizer1KHz"]! + equalizer.gain["Equalizer2KHz"]!)/3
        },
        set: { newValue in
            var equalizer = GoXlr.shared.mixer!.micStatus.equaliser
            equalizer.gain["Equalizer500Hz"] = newValue
            equalizer.gain["Equalizer1KHz"] = newValue
            equalizer.gain["Equalizer2KHz"] = newValue
        }
    )
    
    var simpleTremble: Binding<Float> = .init(
        get: {
            var equalizer = GoXlr.shared.mixer!.micStatus.equaliser
            return (equalizer.gain["Equalizer4KHz"]! + equalizer.gain["Equalizer8KHz"]! + equalizer.gain["Equalizer16KHz"]!)/3
        },
        set: { newValue in
            var equalizer = GoXlr.shared.mixer!.micStatus.equaliser
            equalizer.gain["Equalizer4KHz"] = newValue
            equalizer.gain["Equalizer8KHz"] = newValue
            equalizer.gain["Equalizer16KHz"] = newValue
        }
    )
    
    func sort(lhs: (String, Float), rhs: (String, Float)) -> Bool {
        let lhsParseable = lhs.0.dropFirst(9)
        let rhsParseable = rhs.0.dropFirst(9)
        var lhsValue = 0
        var rhsValue = 0
       
        if lhs.0.contains("KHz") {
            lhsValue = Int(lhsParseable.dropLast(3))!*1000
            
        } else {
            lhsValue = Int(lhsParseable.dropLast(2))!
        }
        if rhs.0.contains("KHz") {
            rhsValue = Int(rhsParseable.dropLast(3))!*1000
        } else {
            rhsValue = Int(rhsParseable.dropLast(2))!
        }
        
        return lhsValue < rhsValue
    }
    
    var body: some View {
        Section(content: {
            DisclosureGroup("Advanced...", isExpanded: $showDetail) {
                HStack {
                    Spacer()
                    ForEach(equalizer.gain.sorted(by: { sort(lhs: $0, rhs: $1) }), id:\.key) { gain, _ in
                        LabelledVSliderElement(label: "\(gain.dropFirst(9))", value: $equalizer.gain[gain].unwrap()!, range: -9...9, sliderWidth: 20, formatValue: { value in
                            return "\(Int(value))"
                        })
                    }.frame(maxWidth: .infinity)
                    Spacer()
                }.frame(height: 300)
            }
            if !showDetail {
                HStack {
                    Spacer()
                    Group {
                        LabelledVSliderElement(label: "Bass", value: simpleBass, range: -9...9, formatValue: { value in
                            return "\(Int(value))"
                        })
                        LabelledVSliderElement(label: "Mid", value: simpleMid, range: -9...9, formatValue: { value in
                            return "\(Int(value))"
                        })
                        LabelledVSliderElement(label: "Tremble", value: simpleTremble, range: -9...9, formatValue: { value in
                            return "\(Int(value))"
                        })
                    }.frame(width: 80)
                    Spacer()
                }.frame(height: 300)
            }
        }, header: {
            HStack {
                Text("Equalizer")
                    .font(.headline)
                Spacer()
                Toggle("Fine Tune", isOn: $fineTune)
                    .toggleStyle(.switch)
                    .controlSize(.mini)
            }
        })
    }
}
