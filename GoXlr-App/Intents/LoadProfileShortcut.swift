//
//  LoadProfileShortcut.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 27/06/2023.
//

import Foundation
import AppIntents
import SwiftUI
import GoXlrKit

enum LoadProfileError: Error, CustomStringConvertible {
    case noGoXlr
    case profileDoesntExist
    
    public var description: String {
        switch self {
        case .noGoXlr:
            return "No GoXLR is connected !"
        case .profileDoesntExist:
            return "This profile doesn't exist !"
        }
        
    }
}

struct LoadProfileShortcut: AppIntent {
    @Parameter(title: "Profile")
    var profile: String

    static var title: LocalizedStringResource = "Load GoXlr Profile"
    static var description: IntentDescription = "Load a specified goxlr profile on your device"

    static var openAppWhenRun = false

    @MainActor
    func perform() async throws -> some IntentResult {
        guard GoXlr.shared.mixer != nil else { throw LoadProfileError.noGoXlr }
        
        guard GoXlr.shared.status!.data.status.files.profiles.contains(profile) else { throw LoadProfileError.noGoXlr }
        
        GoXlr.shared.command(.LoadProfile(profile, true))
        return .result()
    }

    static var parameterSummary: some ParameterSummary {
        Summary("Load GoXlr profile \(\.$profile)")
    }
}

