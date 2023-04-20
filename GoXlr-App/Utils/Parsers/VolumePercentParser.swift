//
//  VolumePercentParser.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 20/04/2023.
//

import Foundation
import SwiftUI

struct VolumePercentageStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Float {
        let parsable = value.dropLast()
        var value = Float((Double(parsable) ?? 0) / 100 * 255).rounded()
        value = max(0, min(255, value))
        return value
    }
}
struct VolumePercentageStyle: ParseableFormatStyle {

    var parseStrategy: VolumePercentageStrategy = .init()

    func format(_ value: Float) -> String {
        return "\((value / 255 * 100).rounded().stringWithoutZeroFraction)%"
    }
}
extension FormatStyle where Self == VolumePercentageStyle {
    static func volumePercent() -> VolumePercentageStyle {
        return VolumePercentageStyle()
    }
}
extension Float {
    var stringWithoutZeroFraction: String {
        return truncatingRemainder(dividingBy: 1) == 0 ? String(format: "%.0f", self) : String(self)
    }
}
