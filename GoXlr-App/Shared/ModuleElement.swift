//
//  ModuleElement.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 18/04/2023.
//

import SwiftUI

struct Module<Content: View>: View {
    let content: Content
    
    init(@ViewBuilder content: () -> Content) {
        self.content = content()
    }
    
    var body: some View {
        VStack {
            HStack {
                Text("Test")
                Spacer()
            }
            self.content
        }
    }
}
