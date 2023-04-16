//
//  AboutView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 07/10/2022.
//

import Foundation
import SwiftUI

struct AboutView: View {
    @State var tabname: String? = "About"
    @EnvironmentObject var mixer: MixerStatus
    var body: some View {
        ScrollView() {
            VStack(alignment: .center) {
                Image("goxlr-macos-banner").resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
                Group {
                    Text("Made with 💝 by Ade_Sky")
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .padding(.top, 1)
                        .padding(.bottom, 40)
                    Text("With the help of the wonderfull work of :")
                        .font(.system(size: 15))
                        .fontWeight(.ultraLight)
                        .padding(.bottom, 20)
                    Text("GoXlr-Utility")
                        .font(.system(size: 25))
                        .fontWeight(.light)
                        .underline()
                        .foregroundColor(.blue)
                        .onTapGesture {
                            NSWorkspace.shared.open(NSURL(string: "https://github.com/GoXLR-on-Linux/GoXLR-Utility")! as URL)
                        }
                    Text("Made by :")
                        .font(.system(size: 20))
                        .fontWeight(.ultraLight)
                        .padding(.top, 1)
                        .padding(.bottom, 2)
                    }
                    HStack {
                        Text("@FrostyCoolSlug (Craig McLure) |")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                        Text("@Dinnerbone (Dinnerbone Nathan Adams) |")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                        Text("@lm41 (lm41 Lars)")
                            .font(.system(size: 15))
                            .fontWeight(.light)
                    }
                    Text("3rd party licenses")
                        .font(.system(size: 15))
                        .fontWeight(.light)
                        .underline()
                        .foregroundColor(.blue)
                        .padding(.top, 3)
                        .onTapGesture {
                            NSWorkspace.shared.open(NSURL(string: "https://github.com/Adelenade/GoXlr-Macos/blob/main/LICENSE-3RD-PARTY")! as URL)
                        }
                    Text("©2022 Adélaïde Sky | MIT License")
                        .padding(.top, 130)
                        .onTapGesture {
                            NSWorkspace.shared.open(NSURL(string: "https://github.com/Adelenade/GoXlr-Macos/blob/main/LICENSE")! as URL)
                        }
            }
        }.navigationTitle(tabname!)
            .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab: "device").environmentObject(mixer)})
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {mixer.profileSheet.toggle()}, label: {
                        Text("Load Profile")
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {MixerStatus().selectedDevice.SaveProfile()}, label: {
                        Text("Save Profile")
                    })
                }
            }

    }
}
