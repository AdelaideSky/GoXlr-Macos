//
//  ColourShowView.swift
//  Colour Wheel
//
//  Created by Christian P on 12/6/20.
//  Copyright © 2020 Christian P. All rights reserved.
//

import SwiftUI

struct ColourShowView: View {
    
    @Binding var rgbColour: RGB
    
    var body: some View {
        /// The view that shows the selected colour.
        RoundedRectangle(cornerRadius: 10)
            .foregroundColor(Color.init(red: Double(rgbColour.r), green: Double(rgbColour.g), blue: Double(rgbColour.b)))
            .frame(width: 300, height: 50)
            /// The outline.
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(Color("Outline"), lineWidth: 5)
            )
            /// The outer shadow.
            .shadow(color: Color("ShadowOuter"), radius: 18)
    }
}

struct ColourShowView_Previews: PreviewProvider {
    static var previews: some View {
        ColourShowView(rgbColour: .constant(RGB(r: 1, g: 1, b: 1)))
    }
}
