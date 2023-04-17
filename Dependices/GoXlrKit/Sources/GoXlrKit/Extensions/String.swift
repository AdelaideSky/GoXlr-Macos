//
//  File.swift
//  
//
//  Created by Adélaïde Sky on 17/02/2023.
//

import Foundation
import SwiftUI

extension String {
    func lowercasingFL() -> String {
      return prefix(1).lowercased() + self.dropFirst()
    }

    mutating func lowercaseFL() {
      self = self.lowercasingFL()
    }
}

extension String {
    func uppercasingFL() -> String {
      return prefix(1).uppercased() + self.dropFirst()
    }

    mutating func uppercaseFL() {
      self = self.lowercasingFL()
    }
}
