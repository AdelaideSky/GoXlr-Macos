//
//  ThresholdParser.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 20/04/2023.
//

import Foundation
import SwiftUI

enum customError: Error {
    case runtimeError(String)
}

struct ThresholdStrategy: ParseStrategy {
    func parse(_ value: String) throws -> Float {
        guard let floatValue = Float(value) else {
            throw customError.runtimeError("Error parsing")
        }
        let adjustedValue = -59 + (59/100) * floatValue
        return max(-59, min(0, adjustedValue))
    }
}
struct ThresholdStyle: ParseableFormatStyle {

    var parseStrategy: ThresholdStrategy = .init()

    func format(_ value: Float) -> String {
        return "\(100-Int(-(value) / 59 * 100))"
    }
}
extension FormatStyle where Self == ThresholdStyle {
    static func thresholdStyle() -> ThresholdStyle {
        return ThresholdStyle()
    }
}
