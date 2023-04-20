//
//  MicView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 20/04/2023.
//

import SwiftUI
import GoXlrKit

struct MicView: View {
    @ObservedObject var micStatus = GoXlr.shared.mixer!.micStatus
    
    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack {
                HStack {
                    Form {
                        MicProfilesElement()
                    }.scrollContentBackground(.hidden)
                        .frame(minWidth: 300)
                        
                    Form {
                        MicSetupMicModule()
                    }.scrollContentBackground(.hidden)
                        .frame(width: 150)
                        .padding(.trailing, 20)
                    Spacer()
                }
                Form {
                    GateMicModule()
                }.scrollContentBackground(.hidden)
            }.frame(width: 700)
        }.formStyle(.grouped)
    }
}
