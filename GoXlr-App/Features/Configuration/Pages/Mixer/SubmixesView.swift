//
//  SubmixesView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 23/06/2023.
//

import SwiftUI
import GoXlrKit

struct SubmixesView: View {
    @EnvironmentObject var levels: Levels
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
struct SubmixChannelView: View {
    @Binding var level: Float
    @Binding var ratio: Float
    @Binding var linked: Bool
    
    var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
