//
//  RoundedParser.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 21/04/2023.
//

import Foundation
import SwiftUI

struct RoundedStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Float {
        return (value as NSString).floatValue
    }
}
struct RoundedStyle: ParseableFormatStyle {

    var parseStrategy: RoundedStrategy = .init()

    func format(_ value: Float) -> String {
        return "\(Int(value))"
    }
}

extension FormatStyle where Self == RoundedStyle {
    static var rounded: RoundedStyle {
        return RoundedStyle()
    }
}
