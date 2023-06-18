//
//  SamplerView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 28/05/2023.
//

import SwiftUI
import GoXlrKit
import SentrySwiftUI

struct SamplerView: View {
    
    @ObservedObject var sampler = GoXlr.shared.mixer!.sampler!
    
    @State var selectedBank: SampleBank = .A
    
    var bankObject: Bank {
        switch sampler.activeBank {
        case .A:
            sampler.banks.A
        case .B:
            sampler.banks.B
        case .C:
            sampler.banks.C
        }
    }
    
    var bankBinding: Binding<Bank> {
        switch sampler.activeBank {
        case .A:
            $sampler.banks.A
        case .B:
            $sampler.banks.B
        case .C:
            $sampler.banks.C
        }
    }
        
    var body: some View {
        HStack {
            List(selection: $sampler.activeBank) {
                Label("Bank A", systemImage: "a.square").tag(SampleBank.A)
                Label("Bank B", systemImage: "b.square").tag(SampleBank.B)
                Label("Bank C", systemImage: "c.square").tag(SampleBank.C)
            }.listStyle(.sidebar)
                .scrollContentBackground(.hidden)
                .frame(width: 130)
            Divider()
                .padding(.leading, -3)
            Form {
                // sample bank & basic options
                SamplerButtonView(bankBinding.TopLeft, bank: $sampler.activeBank, button: .TopLeft)
                    .environmentObject(bankObject)
                SamplerButtonView(bankBinding.TopRight, bank: $sampler.activeBank, button: .TopRight)
                    .environmentObject(bankObject)
                SamplerButtonView(bankBinding.BottomLeft, bank: $sampler.activeBank, button: .BottomLeft)
                    .environmentObject(bankObject)
                SamplerButtonView(bankBinding.BottomRight, bank: $sampler.activeBank, button: .BottomRight)
                    .environmentObject(bankObject)

                
            }.formStyle(.grouped)
                .scrollContentBackground(.hidden)
                .scrollIndicators(.hidden)
        }.navigationTitle("Sampler - Bank \(sampler.activeBank.rawValue)")
            .sentryTrace("Configure - Sampler")
    }
}
