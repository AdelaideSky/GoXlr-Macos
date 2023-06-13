//
//  HomeView.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 23/04/2023.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            Group {
                HStack {
                    Form {
                        ProfilesElement()
                    }
                    Form {
                        MicProfilesElement()
                    }
                }
//                Form {
//                    Section("???") {}
//                }
            }.scrollDisabled(true)
        }.scrollContentBackground(.hidden)
            .formStyle(.grouped)
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
