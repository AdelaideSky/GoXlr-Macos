//
//  MicSetupMicModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 20/04/2023.
//

import SwiftUI

struct MicSetupMicModule: View {
    var body: some View {
        Section("Mic Setup") {
            VStack {
                Button(action: {}, label: {
                    VStack {
                        Image(systemName: "mic")
                            .font(.system(size: 50))
                            .padding(.horizontal)
                            .padding(.bottom)
                        Text("Mic Setup")
                            .font(.title3)
                    }.padding()
                }).buttonStyle(.gentleFilling)
                    .frame(maxHeight: 100)
                    .padding()
                    .padding(.vertical, 10)
            }
        }
    }
}

//TODO: mic setup
