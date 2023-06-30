//
//  NotImplementedView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 21/06/2023.
//

import SwiftUI

@available(macOS, introduced: 14.0)
struct NotImplementedView: View {
    var webUIAvailable: Bool
    
    init(webUIAvailable: Bool) {
        self.webUIAvailable = webUIAvailable
    }
    
    init() {
        self.webUIAvailable = false
    }
    
    var text: Text {
        if webUIAvailable {
            Text("This part of the app still needs some work, come back later !\n\nGo on the [GoXLR Utility's webUI](http://localhost:14564/) to configure this tab")
        } else {
            Text("This part of the app still needs some work, come back later !")
        }
    }
    
    var body: some View {
        ContentUnavailableView("Work in progress...", systemImage: "rainbow", description: text)
            .symbolRenderingMode(.multicolor)
            .symbolEffect(.variableColor.cumulative.dimInactiveLayers.nonReversing)
    }
}
