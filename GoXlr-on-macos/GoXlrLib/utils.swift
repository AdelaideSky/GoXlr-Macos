//
//  utils.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 01/08/2022.
//

import Foundation
import SwiftUI


extension StringProtocol {
    func dropping<S: StringProtocol>(prefix: S) -> SubSequence { hasPrefix(prefix) ? dropFirst(prefix.count) : self[...] }
    var hexaToDecimal: Int { Int(dropping(prefix: ""), radix: 16) ?? 0 }
    var hexaToBinary: String { .init(hexaToDecimal, radix: 2) }
    var decimalToHexa: String { .init(Int(self) ?? 0, radix: 16) }
    var decimalToBinary: String { .init(Int(self) ?? 0, radix: 2) }
    var binaryToDecimal: Int { Int(dropping(prefix: "0b"), radix: 2) ?? 0 }
    var binaryToHexa: String { .init(binaryToDecimal, radix: 16) }
}
extension RGB {
    public func toHex() -> String {
        
        return String(format:"%02X", Int(self.r*255)) + String(format:"%02X", Int(self.g*255)) + String(format:"%02X", Int(self.b*255))
    }
    public func onChangeCompatible() -> CGFloat {
        return (self.r+self.g+self.b)
    }
    
}
extension HSV {
    public func onChangeCompatible(br:CGFloat) -> CGFloat {
        return (self.h+self.s+self.v+br)
    }
    
}
extension String {
    public func toRGB() -> RGB {
        
        let string = Array(self)
        
        let r = CGFloat((String(string[0])+String(string[1])).hexaToDecimal)/255
        
        let g = CGFloat((String(string[2])+String(string[3])).hexaToDecimal)/255
        

        let b = CGFloat((String(string[4])+String(string[5])).hexaToDecimal)/255


        return RGB(r: r, g: g, b: b)
    }
}
