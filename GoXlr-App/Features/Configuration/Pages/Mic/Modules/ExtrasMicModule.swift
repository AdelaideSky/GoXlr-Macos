//
//  ExtrasMicModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 21/04/2023.
//

import SwiftUI
import GoXlrKit

struct ExtrasMicModule: View {
    @ObservedObject var levels = GoXlr.shared.mixer!.levels
    var body: some View {
        Section("Extras") {
            HStack {
                LabelledVSliderElement(label: "DeEsser", value: $levels.deess, range: 0...100, sliderWidth: 20, sliderHeight: 150)
                LabelledVSliderElement(label: "Bleep", value: $levels.bleep, range: -36...0, sliderWidth: 20, sliderHeight: 150)
            }
        }
    }
}
