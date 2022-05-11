//
//  SettingsView.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 26/04/2022.
//

import SwiftUI

struct NotCreatedView: View {
    @State var tabname: String? = "Not yet supported"
    var body: some View {
        VStack(alignment: .center) {
            Text("Not yet supported !")
                .bold()
                .font(.largeTitle)
                .fontWeight(.heavy)
            Text("Come back later ! :3")
                .padding(.top)
        }.navigationTitle(tabname!)
    }
}
