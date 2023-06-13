//
//  Tabs.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 18/04/2023.
//

import Foundation
import GoXlrKit

struct Tab: Identifiable, Hashable {
    init(_ id: TabId, name: String, icon: String) {
        self.id = id
        self.name = name
        self.icon = icon
    }
    
    var id: TabId
    var name: String
    var icon: String
}

struct TabGroup: Identifiable {
    init(_ name: String, tabs: [Tab]) {
        self.name = name
        self.tabs = tabs
    }
    
    var id: String {
        "\(name)+\(tabs.count)"
    }
    
    var name: String
    var tabs: [Tab]
    
}

enum TabId: String {
    case home
    
    case mic
    case mixer
    case effects
    case sampler
    case routing

    case lightGlobal
    case lightMixer
    case lightFX
    case lightSampler
}

struct ConfigurationPages {
    let full: [TabGroup] = [
        .init("", tabs: [
            .init(.home, name: "Home", icon: "house")
        ]),
        .init("Audio", tabs: [
            .init(.mic, name: "Mic", icon: "mic"),
            .init(.mixer, name: "Mixer", icon: "slider.vertical.3"),
            .init(.effects, name: "Effects", icon: "fx"),
            .init(.sampler, name: "Sampler", icon: "waveform"),
            .init(.routing, name: "Routing", icon: "app.connected.to.app.below.fill"),
        ]),
        .init("Lightning", tabs: [
            .init(.lightGlobal, name: "Global", icon: "sun.min"),
            .init(.lightMixer, name: "Mixer", icon: "slider.vertical.3"),
            .init(.lightFX, name: "Effects", icon: "fx"),
            .init(.lightSampler, name: "Sampler", icon: "waveform"),
        ])
    ]
    let mini: [TabGroup] = [
        .init("", tabs: [
            .init(.home, name: "Home", icon: "house")
        ]),
        .init("Audio", tabs: [
            .init(.mic, name: "Mic", icon: "mic"),
            .init(.mixer, name: "Mixer", icon: "slider.vertical.3"),
            .init(.routing, name: "Routing", icon: "app.connected.to.app.below.fill"),
        ]),
        .init("Lightning", tabs: [
            .init(.lightGlobal, name: "Global", icon: "sun.min"),
            .init(.lightMixer, name: "Mixer", icon: "slider.vertical.3"),
        ])
    ]
    public func appropriateTabs(_ goxlr: GoXlr) -> [TabGroup] {
        
        guard goxlr.mixer != nil else { return [] }
        
        switch goxlr.mixer?.hardware.deviceType {
        case .Full:
            return full
        case .Mini:
            return mini
        default:
            return []
        }
    }
}
