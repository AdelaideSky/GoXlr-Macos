//
//  ProfilesMenubarModuleConfiguration.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 26/04/2023.
//

import SwiftUI
import GoXlrKit

class FadersMenubarModuleConfig: ObservableObject {
    
    @AppStorage(AppSettingsKeys.mmodFaders_Fader1.rawValue)
    var fader1: ChannelName = .System
    
    @AppStorage(AppSettingsKeys.mmodFaders_Fader2.rawValue)
    var fader2: ChannelName? = nil
    
    @AppStorage(AppSettingsKeys.mmodFaders_Fader3.rawValue)
    var fader3: ChannelName? = nil
}


extension Optional: RawRepresentable where Wrapped == ChannelName {
    public typealias RawValue = String
    
    public var rawValue: String {
        if let name = self {
            return name.rawValue
        } else {
            return ""
        }
    }
    
    public init?(rawValue: String) {
        guard rawValue != "" else { return nil }
        self = ChannelName(rawValue: rawValue)
    }
}
