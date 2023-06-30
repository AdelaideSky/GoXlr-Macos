//
//  WhatsNewStore.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 30/06/2023.
//

import Foundation
import WhatsNewKit
import SwiftUI

extension ConfigurationScene: WhatsNewCollectionProvider {

    var whatsNewCollection: WhatsNewCollection {
        WhatsNew(version: "2.1.0",
                 title: .goxlr,
                 features: [
                    .init(image: .init(systemName: "waveform"), title: "Sampler configuration support", subtitle: "Enjoy the brand new sampler configuration tab, as well as its menubar module!"),
                    .init(image: .init(systemName: "mic.and.signal.meter"), title: "Mic Setup is now working", subtitle: "You can now set your mic gain and see its live level preview directly in the app! \nClick mic setup on the mic configuration tab to get started."),
                    .init(image: .init(systemName: "gear.badge"), title: "New settings available", subtitle: "Go in the settings window to customise your updates preferences and more. \nYou can also configure and learn more about the GoXLR-Utility there."),
                    .bugs
                 ],
                 secondaryAction: .learnMore
        )
    }

}

fileprivate extension WhatsNew.Title {
    
    static var goxlr: WhatsNew.Title {
        .init(
           text: .init(
               "What's New in "
               + AttributedString(
                   "GoXlr-App",
                   attributes: .foregroundColor(.init(.logo))
               )
               + AttributedString(
                   "\n\(Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "")",
                   attributes: .font(.body).foregroundColor(.secondary))
               )
           )
    }
}

fileprivate extension WhatsNew.Feature {
    
    static var bugs: WhatsNew.Feature {
        .init(image: .init(systemName: "ladybug"), title: "Squashed bugs", subtitle: "We also squashed some silly bugs !\nIf you experience any weird behaviour, don't forget to let us know !")
    }
}

fileprivate extension WhatsNew.SecondaryAction {
    
    static var learnMore: WhatsNew.SecondaryAction {
        .init(title: "Learn more", action: .openURL(URL(string: "https://github.com/AdelaideSky/GoXlr-Macos/releases/latest")))
    }
}

extension AttributeContainer {
    
    /// A AttributeContainer with a given foreground color
    /// - Parameter color: The foreground color
    static func foregroundColor(
        _ color: Color
    ) -> Self {
        var container = Self()
        container.foregroundColor = color
        return container
    }
    
    static func font(
        _ font: Font
    ) -> Self {
        var container = Self()
        container.font = font
        return container
    }
}
