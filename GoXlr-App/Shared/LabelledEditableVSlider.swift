//
//  LabelledEditableVSlider.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 21/04/2023.
//

import SwiftUI

struct LabelledEditableVSliderElement<Format: ParseableFormatStyle>: View where Format.FormatInput == Float, Format.FormatOutput == String {
    
    var label: String
    var format: Format
    
    @Binding var value: Float
    
    var range: ClosedRange<Float>
    var sliderWidth: Float = 25
    var sliderHeight: Float = 200
    var icon: String = ""
    var unity: String = ""
    
    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            Text(label).font(.system(.subheadline)).padding(.bottom, 10)
            VSlider(value: $value, image: icon, range: range, sliderWidth: sliderWidth, sliderHeight: sliderHeight)
                .padding(.bottom, 20)
                .frame(width: 80)
            HStack(spacing: 0) {
                TextField(value: $value, format: format, label: {})
                    .textFieldStyle(.plain)
                    .focused($focus)
                    .onSubmit {
                        focus.toggle()
                    }
                    .fixedSize()
                    .frame(width: nil)
                Text(unity)
            }.font(.system(.body))
                .foregroundColor(.secondary)
        }.padding(.horizontal, 5)
    }
}
struct LabelledVSliderElement: View {
    var label: String
    
    @Binding var value: Float
    
    var range: ClosedRange<Float>
    var sliderWidth: Float = 25
    var sliderHeight: Float = 200
    var icon: String = ""
    var unity: String = ""
    
    var formatValue: (Float) -> String = { $0.rounded().roundedString }
    
    @FocusState var focus: Bool
    
    var body: some View {
        VStack {
            Text(label).font(.system(.subheadline)).padding(.bottom, 10)
            VSlider(value: $value, image: icon, range: range, sliderWidth: sliderWidth, sliderHeight: sliderHeight)
                .padding(.bottom, 20)
            Text(formatValue(value) + unity).font(.system(.body))
                .foregroundColor(.secondary)
        }.padding(.horizontal, 5)
    }
}
