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
                    Group {
                        Form {
                            MicProfilesElement()
                        }.frame(minWidth: 300)
                            
                        Form {
                            MicSetupMicModule()
                        }.frame(width: 150)
//                            .padding(.trailing, 20)
                        Form {
                            ExtrasMicModule()
                        }.frame(width: 165)
                    }.scrollContentBackground(.hidden)
                }
                Form {
                    GateMicModule()
                    switch GoXlr.shared.mixer!.hardware.deviceType {
                    case .Full:
                        EqualizerMicModule()
                    case .Mini:
                        EqualizerMiniMicModule()
                    }
                    CompressorMicModule()
                }.scrollContentBackground(.hidden)
            }.frame(width: 700)
        }.formStyle(.grouped)
            .frame(maxWidth: .infinity)
    }
}
