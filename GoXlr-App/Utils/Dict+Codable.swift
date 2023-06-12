//
//  Dict+Codable.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 12/06/2023.
//

import Foundation
import SwiftUI

extension [String:String]: RawRepresentable {
    
    public init?(rawValue: String) {
        guard let data = rawValue.data(using: .utf8),
              let result = try? JSONDecoder().decode([String:String].self, from: data)
        else {
            return nil
        }
        self = result
    }
    
    public var rawValue: String {
        guard let data = try? JSONEncoder().encode(self),
              let result = String(data: data, encoding: .utf8)
        else {
            return "[]"
        }
        return result
    }
}
extension Dictionary {
    mutating func changeKey(from: Key, to: Key) {
        self[to] = self[from]
        self.removeValue(forKey: from)
    }
}
