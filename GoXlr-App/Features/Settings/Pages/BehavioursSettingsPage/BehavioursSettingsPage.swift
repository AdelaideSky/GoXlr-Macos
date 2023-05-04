//
//  BehavioursSettingsPage.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 30/04/2023.
//

import SwiftUI
import GoXlrKit

struct BehavioursSettingsPage: View {
    @ObservedObject var mixer = GoXlr.shared.mixer!
    @State var selection: GoXLRCommand? = nil
    var body: some View {
        Form {
            Section("Shutdown") {
                List(selection: $selection) {
                    
                }.padding(.bottom, 24)
                    .overlay(alignment: .bottom, content: {
                        VStack(alignment: .leading, spacing: 0) {
                            Divider()
                            HStack(spacing: 0) {
                                Button(action: {}) {
                                    Image(systemName: "plus")
                                }.buttonStyle(.plain)
                                Divider().frame(height: 16)
                                Button(action: {}) {
                                    Image(systemName: "minus")
                                }.buttonStyle(.plain)
                                .disabled(selection == nil ? true : false)
                            }
                            .buttonStyle(.borderless)
                        }
                        .background(Rectangle().opacity(0.04))
                    })
            }
        }.formStyle(.grouped)
            .scrollContentBackground(.hidden)
    }
}

struct BehavioursSettingsPage_Previews: PreviewProvider {
    static var previews: some View {
        BehavioursSettingsPage()
    }
}
