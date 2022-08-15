//
//  ColorWheel.swift
//  Colour Wheel
//
//  Created by Christian P on 9/6/20.
//  Copyright © 2020 Christian P. All rights reserved.
//

import SwiftUI

/// The actual colour wheel view.
struct ColourWheel: View {
    
    /// Draws at a specified radius.
    var radius: CGFloat
    
    /// The RGB colour. Is a binding as it can change and the view will update when it does.
    @Binding var rgbColour: HSV
    
    /// The brightness/value of the colour wheel
    @Binding var brightness: CGFloat
    
    var body: some View {
        
        /// Geometry reader so we can know more about the geometry around and within the view.
        return GeometryReader { geometry in
            ZStack {
                
                /// The colour wheel. See the definition.
                CIHueSaturationValueGradientView(radius: self.radius, brightness: self.$brightness)
                    /// Smoothing out of the colours.
                    .blur(radius: 10)
                    /// The outline.
                    .overlay(
                        Circle()
                            .size(CGSize(width: self.radius, height: self.radius))
                            .stroke(Color("Outline"), lineWidth: 5)
                            /// Inner shadow.
                            .shadow(color: Color("ShadowInner"), radius: 5)
                    )
                    /// Clip inner shadow.
                    .clipShape(
                        Circle()
                            .size(CGSize(width: self.radius, height: self.radius))
                    )
                    /// Outer shadow.
                    .shadow(color: Color("ShadowOuter"), radius: 5)
                
                /// This is not required and actually makes the gradient less "accurate" but looks nicer. It's basically just a white radial gradient that blends the colours together nicer. We also slowly dissolve it as the brightness/value goes down.
                RadialGradient(gradient: Gradient(colors: [Color.white.opacity(0.8*Double(self.brightness)), .clear]), center: .center, startRadius: 0, endRadius: self.radius/2 - 10)
                    .blendMode(.screen)
                    
                /// The little knob that shows selected colour.
                Circle()
                    .frame(width: 10, height: 10)
                    .offset(x: (self.radius/2 - 10) * self.rgbColour.s)
                    .rotationEffect(.degrees(-Double(self.rgbColour.h)))
                
            }
            /// The gesture so we can detect touches on the wheel.
            .gesture(
                DragGesture(minimumDistance: 0.1, coordinateSpace: .global)
                    .onChanged { value in
                        
                        /// Work out angle which will be the hue.
                        let y = geometry.frame(in: .global).midY - value.location.y
                        let x = value.location.x - geometry.frame(in: .global).midX
                        
                        /// Use `atan2` to get the angle from the center point then convert than into a 360 value with custom function(find it in helpers).
                        let hue = atan2To360(atan2(y, x))
                        
                        /// Work out distance from the center point which will be the saturation.
                        let center = CGPoint(x: geometry.frame(in: .global).midX, y: geometry.frame(in: .global).midY)
                        
                        /// Maximum value of sat is 1 so we find the smallest of 1 and the distance.
                        let saturation = min(distance(center, value.location)/(self.radius/2), 1)
                        
                        /// Convert HSV to RGB and set the colour which will notify the views.
                        self.rgbColour = HSV(h: hue, s: saturation, v: self.brightness)
                        
                    }
            )
        }
        /// Set the size.
        .frame(width: self.radius, height: self.radius)
    }
}
