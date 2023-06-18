//
//  SamplerButtonView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 18/06/2023.
//

import SwiftUI
import GoXlrKit

struct SamplerButtonView: View {
    @ObservedObject var files = GoXlr.shared.status!.data.status.files
    @ObservedObject var sampler = GoXlr.shared.mixer!.sampler!
    
    @EnvironmentObject var bank: Bank
    
    @Binding var button: SamplerButton
    
    @State var buttonType: SampleButtons
    @Binding var bankType: SampleBank
    
    @State var sampleSelection: Int? = nil
    
    var name: String {
        switch buttonType {
        case .TopLeft:
            "Top Left"
        case .TopRight:
            "Top Right"
        case .BottomLeft:
            "Bottom Left"
        case .BottomRight:
            "Bottom Right"
        }
    }
    
    var icon: String {
        switch buttonType {
        case .TopLeft:
            "rectangle.inset.topleft.filled"
        case .TopRight:
            "rectangle.inset.topright.filled"
        case .BottomLeft:
            "rectangle.inset.bottomleft.filled"
        case .BottomRight:
            "rectangle.inset.bottomright.filled"
        }
    }
    
    init(_ button: Binding<SamplerButton>, bank: Binding<SampleBank>, button buttonType: SampleButtons) {
        self.buttonType = buttonType
        self._bankType = bank
        self._button = button
    }
    
    var body: some View {
        Section(content: {
            HStack {
                Text("Function")
                Spacer()
                Picker("", selection: $button.function) {
                    Text("Play-Next").tag(SamplePlaybackMode.PlayNext)
                    Text("Play-Stop").tag(SamplePlaybackMode.PlayStop)
                    Text("Play-Fade").tag(SamplePlaybackMode.PlayFade)
                    Text("Stop on Release").tag(SamplePlaybackMode.StopOnRelease)
                    Text("Fade on Release").tag(SamplePlaybackMode.FadeOnRelease)
                    Text("Loop").tag(SamplePlaybackMode.Loop)
                }
            }
            HStack {
                Text("Play order")
                Spacer()
                Picker("", selection: $button.order) {
                    Text("Sequential").tag(SamplePlayOrder.Sequential)
                    Text("Random").tag(SamplePlayOrder.Random)
                }
            }
            DisclosureGroup("Samples") {
                HStack(alignment: .top) {
                    
                    SamplesListView($button.samples, selection: $sampleSelection, button: buttonType, bank: bankType)

                    SampleEditView($button.samples, isPlaying: $button.isPlaying, selection: $sampleSelection, buttonType: buttonType, bank: bankType)
                }
            }
        }, header:{
            Label(name, systemImage: icon)
        }).sheet(isPresented: Binding(get: {sampler.processingState.progress != nil}, set: {_ in})) {
            VStack {
                ProgressView(value: (sampler.processingState.progress ?? 0)/100, label: {
                    Text("Analysing sample...")
                        .font(.headline)
                    Text("Please wait until the daemon finishes analysing the sample")
                        .font(.caption)
                })
            }.padding()
        }
        .alert("Error adding sample",
               isPresented: Binding(get: {sampler.processingState.lastError != nil}, set: {_,_ in GoXlr.shared.command(.ClearSampleProcessError)}),
               actions: {
            Button("OK", role: .cancel) {}
        }) {
            Text(sampler.processingState.lastError ?? "Unknown")
        }
    }
}
