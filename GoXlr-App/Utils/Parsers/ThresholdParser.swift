//
//  ThresholdParser.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 20/04/2023.
//

import Foundation
import SwiftUI

struct ThresholdStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Float {
        let parsable = value.dropLast()
        var value = -Float((Double(parsable) ?? 0) / 100 * 59).rounded()
        value = max(-59, min(0, value))
        return value
    }
}
struct ThresholdStyle: ParseableFormatStyle {

    var parseStrategy: VolumePercentageStrategy = .init()

    func format(_ value: Float) -> String {
        return "\((-(value) / 59 * 100).rounded().stringWithoutZeroFraction)"
    }
}
extension FormatStyle where Self == ThresholdStyle {
    static func thresholdStyle() -> ThresholdStyle {
        return ThresholdStyle()
    }
}
