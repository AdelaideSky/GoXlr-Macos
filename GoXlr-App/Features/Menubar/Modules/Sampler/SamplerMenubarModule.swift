//
//  SamplerMenubarModule.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 21/06/2023.
//

import SwiftUI
import GoXlrKit

struct SamplerMenubarModule: View {
    @ObservedObject var sampler = GoXlr.shared.mixer!.sampler!
    
    @State var selectedButton: SampleButtons = .TopLeft
    @State var selectedSample: Int? = nil
    
    var bank: Binding<Bank> {
        switch sampler.activeBank {
        case .A:
            $sampler.banks.A
        case .B:
            $sampler.banks.B
        case .C:
            $sampler.banks.C
        }
    }
    var button: Binding<SamplerButton> {
        switch selectedButton {
        case .TopLeft:
            bank.TopLeft
        case .TopRight:
            bank.TopRight
        case .BottomLeft:
            bank.BottomLeft
        case .BottomRight:
            bank.BottomRight
        }
    }
    var height: CGFloat {
        if button.samples.count > 0 {
            27+(CGFloat(button.samples.count)*33)
        } else {
            100
        }
    }
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Picker("Bank", selection: $sampler.activeBank) {
                    Text("A").tag(SampleBank.A)
                    Text("B").tag(SampleBank.B)
                    Text("C").tag(SampleBank.C)
                }.fixedSize()
                    .labelsHidden()
                Picker("Button", selection: $selectedButton) {
                    Text("Top Left").tag(SampleButtons.TopLeft)
                    Text("Top Right").tag(SampleButtons.TopRight)
                    Text("Bottom Left").tag(SampleButtons.BottomLeft)
                    Text("Bottom Right").tag(SampleButtons.BottomRight)
                }.fixedSize()
                    .labelsHidden()
            }.controlSize(.mini)
            SamplesListView(button.samples, selection: $selectedSample, button: selectedButton, bank: sampler.activeBank, notGrouped: true)
                .frame(height: 100)
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }.padding(.top, -18)

    }
}
