//
//  NotSupportedView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 07/07/2022.
//

import SwiftUI

struct NotCreatedView: View {
    @State var tabname: String? = "Not yetz supported"
    @EnvironmentObject var mixer: MixerStatus
    var body: some View {
        VStack(alignment: .center) {
            Text("Not yet supported !")
                .bold()
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("Come back later ! :3")
                .padding(.top)
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
