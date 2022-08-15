//
//  CustomSlider.swift
//  Colour Wheel
//
//  Created by Christian P on 12/6/20.
//  Copyright © 2020 Christian P. All rights reserved.
//

import SwiftUI

struct CustomSlider: View {
    
    /// The slider will also show the selected colour.
    @Binding var rgbColour: RGB
    
    /// The value that the slider is currently showing.
    @Binding var value: CGFloat
    
    /// The range of the slider.
    var range: ClosedRange<CGFloat>
    
    /// What the last x offset of the slider knob was before it was moved.
    @State var lastOffset: CGFloat = 0
    
    /// If the knob is being touched or not.
    @State var isTouchingKnob = false
    
    /// Set the leading and trailing offset of the track for the knob.
    var leadingOffset: CGFloat = 8
    var trailingOffset: CGFloat = 8
    
    /// Set the knob size.
    var knobSize: CGSize = CGSize(width: 10, height: 10)
    
    var body: some View {
        GeometryReader { geometry in
            ZStack {
                
                /// The slider track.
                RoundedRectangle(cornerRadius: 30)
                    /// Set the colour to be the selected colour.
                    .foregroundColor(Color.init(red: Double(self.rgbColour.r), green: Double(self.rgbColour.g), blue: Double(self.rgbColour.b)))
                    /// The outline.
                    .overlay(
                        RoundedRectangle(cornerRadius: 30)
                            .stroke(Color("Outline"), lineWidth: 1)
                    )
                    /// The outer shadow.
                    .shadow(color: Color("ShadowOuter"), radius: 10)
                HStack {
                    /// The knob.
                    ZStack {
                        /// The knob outline.
                        RoundedRectangle(cornerRadius: 50)
                            .stroke(Color("Outline"), lineWidth: self.isTouchingKnob ? 4 : 5)
                            .frame(width: self.knobSize.width, height: self.knobSize.height)
                        /// The knob center.
                        RoundedRectangle(cornerRadius: 50)
                            .foregroundColor(Color.init(red: Double(self.rgbColour.r-0.1), green: Double(self.rgbColour.g-0.1), blue: Double(self.rgbColour.b-0.1)))
                            .frame(width: self.knobSize.width, height: self.knobSize.height)
                    }
                    /// Set the offset of the knob.
                    .offset(x: self.$value.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset)))
                    /// The knob shadow.
                    .shadow(color: Color("ShadowOuter"), radius: 10)
                    /// Gesture to detect drag.
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                
                                /// Tell view we are now touching the knob and record the position before we move it.
                                self.isTouchingKnob = true
                                if abs(value.translation.width) < 0.1 {
                                    self.lastOffset = self.$value.wrappedValue.map(from: self.range, to: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset))
                                }
                                
                                /// Calculate what the new x offset as well as the value should be.
                                let sliderPos = max(0 + self.leadingOffset, min(self.lastOffset + value.translation.width, geometry.size.width - self.knobSize.width - self.trailingOffset))
                                let sliderVal = sliderPos.map(from: self.leadingOffset...(geometry.size.width - self.knobSize.width - self.trailingOffset), to: self.range)
                                
                                self.value = sliderVal
                            }
                            .onEnded { _ in
                                
                                /// Gesture is ended and we are no longer touching the knob.
                                self.isTouchingKnob = false
                            }
                        )
                    /// Spacer in HStack aligns the knob to the left so that we don't have to deal with abs().
                    Spacer()
                }
            }
        }
        .frame(height: 4)
    }
}

struct CustomSlider_Previews: PreviewProvider {
    static var previews: some View {
        CustomSlider(rgbColour: .constant(RGB(r: 0.5, g: 0.1, b: 0.9)), value: .constant(10), range: 1...100)
    }
}


