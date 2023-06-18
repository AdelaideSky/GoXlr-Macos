//
//  AddSamplePopupView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 18/06/2023.
//

import SwiftUI
import GoXlrKit

struct AddSamplePopupView: View {
    @ObservedObject var files = GoXlr.shared.status!.data.status.files
    
    var buttonType: SampleButtons
    var bankType: SampleBank
    
    @State var sampleQuery: String = ""
    @State var addSampleSelection: String? = nil
    @Binding var shown: Bool
    
    var filteredSamples: [String:String] {
        files.samples.filter({$0.value.lowercased().contains(sampleQuery.lowercased()) || sampleQuery.isEmpty })
    }
    
    init(_ buttonType: SampleButtons, bankType: SampleBank, shown: Binding<Bool>) {
        self.buttonType = buttonType
        self.bankType = bankType
        self._shown = shown
    }
    
    var body: some View {
        VStack {
            GroupBox {
                TextField("Search", text: $sampleQuery)
                    .textFieldStyle(.plain)
                    .onSubmit {
                        if let sample = addSampleSelection {
                            GoXlr.shared.command(.AddSample(bankType, buttonType, sample))
                        }
                        shown.toggle()
                    }
                    .padding(5)
            }.padding(5)
            GroupBox {
                Form {
                    if filteredSamples.isEmpty {
                        HStack {
                            Spacer()
                            if sampleQuery.isEmpty {
                                Text("You don't have samples yet ! Hold a sample button to record a sample, or drop a file in the button's samples list !")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .padding(.horizontal)
                            } else {
                                Text("No match for your search...")
                                    .font(.caption)
                                    .foregroundStyle(.secondary)
                                    .multilineTextAlignment(.center)
                                    .padding()
                                    .padding(.horizontal)
                            }
                            Spacer()
                        }
                    } else {
                        List(selection: $addSampleSelection) {
                            ForEach(filteredSamples.sorted(by: {$0.value > $1.value}), id:\.key) { sample in
                                Button(sample.value) {
                                    GoXlr.shared.command(.AddSample(bankType, buttonType, sample.value))
                                    shown.toggle()
                                }.buttonStyle(.plain)
                                    .padding(1)
                                    .tag(sample.value)
                            }
                        }
                    }
                }.formStyle(.grouped)
                    .scrollContentBackground(.hidden)
                    .scrollIndicators(.hidden)
                    .padding(-20)
                    .onChange(of: sampleQuery) { newValue in
                        addSampleSelection = filteredSamples.sorted(by: {$0.value > $1.value}).first?.value
                    }
            }.padding(5)
                .padding(.top, -10)
            
        }
        .frame(width: 200, height: 300)
    }
}
