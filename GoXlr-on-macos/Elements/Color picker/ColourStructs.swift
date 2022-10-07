//
//  ColourStructs.swift
//  color wheel
//
//  Created by Christian P on 9/6/20.
//  Copyright © 2020 Christian P. All rights reserved.
//

import SwiftUI

/// This was all taken from here and only slightly edited. -> https://gist.github.com/FredrikSjoberg/cdea97af68c6bdb0a89e3aba57a966ce

/// Struct that holds red, green and blue values. Also has a `hsv` value that converts it's values to hsv.
public struct RGB {

    var r: CGFloat // Percent [0,1]
    var g: CGFloat // Percent [0,1]
    var b: CGFloat // Percent [0,1]
    
    static func toHSV(r: CGFloat, g: CGFloat, b: CGFloat) -> HSV {
        let min = r < g ? (r < b ? r : b) : (g < b ? g : b)
        let max = r > g ? (r > b ? r : b) : (g > b ? g : b)
        
        let v = max
        let delta = max - min
        
        guard delta > 0.00001 else { return HSV(h: 0, s: 0, v: max) }
        guard max > 0 else { return HSV(h: -1, s: 0, v: v) } // Undefined, achromatic grey
        let s = delta / max
        
        let hue: (CGFloat, CGFloat) -> CGFloat = { max, delta -> CGFloat in
            if r == max { return (g-b)/delta } // between yellow & magenta
            else if g == max { return 2 + (b-r)/delta } // between cyan & yellow
            else { return 4 + (r-g)/delta } // between magenta & cyan
        }
        
        let h = hue(max, delta) * 60 // In degrees
        
        return HSV(h: (h < 0 ? h+360 : h) , s: s, v: v)
    }
    
    var hsv: HSV {
        return RGB.toHSV(r: self.r, g: self.g, b: self.b)
    }
}

/// Struct that holds hue, saturation, value values. Also has a `rgb` value that converts it's values to hsv.
struct HSV {
    var h: CGFloat // Angle in degrees [0,360] or -1 as Undefined
    var s: CGFloat // Percent [0,1]
    var v: CGFloat // Percent [0,1]
    
    static func toRGB(h: CGFloat, s: CGFloat, v: CGFloat) -> RGB {
        if s == 0 { return RGB(r: v, g: v, b: v) } // Achromatic grey
        
        let angle = (h >= 360 ? 0 : h)
        let sector = angle / 60 // Sector
        let i = floor(sector)
        let f = sector - i // Factorial part of h
        
        let p = v * (1 - s)
        let q = v * (1 - (s * f))
        let t = v * (1 - (s * (1 - f)))
        
        switch(i) {
        case 0:
            return RGB(r: v, g: t, b: p)
        case 1:
            return RGB(r: q, g: v, b: p)
        case 2:
            return RGB(r: p, g: v, b: t)
        case 3:
            return RGB(r: p, g: q, b: v)
        case 4:
            return RGB(r: t, g: p, b: v)
        default:
            return RGB(r: v, g: p, b: q)
        }
    }
    
    var rgb: RGB {
        return HSV.toRGB(h: self.h, s: self.s, v: self.v)
    }
    
}
