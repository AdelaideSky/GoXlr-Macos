//
//  SamplesListView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 18/06/2023.
//

import SwiftUI
import GoXlrKit
import UniformTypeIdentifiers

struct SamplesListView: View {
    var bankType: SampleBank
    var buttonType: SampleButtons
    
    @Binding var sampleSelection: Int?
    @Binding var samples: [Sample]
    
    @State var showingAddPopup = false
    
    var notGrouped: Bool = false
    
    init(_ samples: Binding<[Sample]>, selection: Binding<Int?>, button: SampleButtons, bank: SampleBank) {
        self._samples = samples
        self._sampleSelection = selection
        self.buttonType = button
        self.bankType = bank
    }
    init(_ samples: Binding<[Sample]>, selection: Binding<Int?>, button: SampleButtons, bank: SampleBank, notGrouped: Bool) {
        self._samples = samples
        self._sampleSelection = selection
        self.buttonType = button
        self.bankType = bank
        self.notGrouped = notGrouped
    }
    var content: some View {
        List(selection: $sampleSelection) {
            if samples.isEmpty {
                Text("Click the plus button to add a sample to this button or drop a audio file !")
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .multilineTextAlignment(.center)
                    .padding()
                    .padding(.horizontal)
            } else {
                ForEach(0...(samples.count-1), id:\.self) { id in
                    Text(samples[id].name)
                        .padding(.vertical, 4)
                        .tag(id)
                }
                .onDelete() { indexSet in
                    for index in indexSet {
                        GoXlr.shared.command(.RemoveSampleByIndex(bankType, buttonType, index))
                    }
                    return
                }
            }
        }.listStyle(.plain)
            .padding(.bottom, 27)
            .onDrop(of: [.fileURL], isTargeted: .constant(false)) { providers -> Bool in
                for provider in providers {
                    provider.loadItem(forTypeIdentifier: UTType.fileURL.identifier, options: nil) { item, error in
                        guard let data = item as? Data, let url = URL(dataRepresentation: data, relativeTo: nil) else { return }
                        
                        guard UTType(filenameExtension: url.pathExtension)?.conforms(to: .audio) ?? false else { return }
                        
                        GoXlr.shared.importFile(url, path: .samples)
                        print(bankType)
                        print(buttonType)
                        print(url.lastPathComponent)
                        GoXlr.shared.command(.AddSample(bankType, buttonType, url.lastPathComponent))
                    }
                }
                return true
            }
            .overlay(alignment: .bottom, content: {
                VStack(alignment: .leading, spacing: 0) {
                    Divider()
                    Spacer()
                    HStack(spacing: 5) {
                        
                        Button(action: {
                            showingAddPopup.toggle()
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(.white.opacity(0.001))
                                Image(systemName: "plus")
                            }.fixedSize()
                        }.buttonStyle(.plain)
                            .popover(isPresented: $showingAddPopup) {
                                AddSamplePopupView(buttonType, bankType: bankType, shown: $showingAddPopup)
                            }
                        
                        Button(action: {
                            GoXlr.shared.command(.RemoveSampleByIndex(bankType, buttonType, sampleSelection!))
                            sampleSelection = nil
                        }) {
                            ZStack {
                                Rectangle()
                                    .fill(.white.opacity(0.001))
                                Image(systemName: "minus")
                            }.fixedSize()
                        }.buttonStyle(.plain)
                            .disabled(sampleSelection == nil ? true : false)
                        
                    }.padding(.leading, 10)
                        .buttonStyle(.borderless)
                    
                    Spacer()
                    
                }.frame(height: 27)
                    .background(Rectangle().opacity(0.04))
            })
    }
    var body: some View {
        if !notGrouped {
            GroupBox {
                content
            }
        } else {
            content
        }
    }
}
