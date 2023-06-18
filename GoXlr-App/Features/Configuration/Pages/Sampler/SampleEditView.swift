//
//  SampleEditView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 18/06/2023.
//

import SwiftUI
import GoXlrKit
import DSWaveformImageViews

struct SampleEditView: View {
    @ObservedObject var files = GoXlr.shared.status!.data.status.files
    
    var bankType: SampleBank
    var buttonType: SampleButtons
    
    @Binding var sampleSelection: Int?
    @Binding var samples: [Sample]
    @Binding var isPlaying: Bool
    
    init(_ samples: Binding<[Sample]>, isPlaying: Binding<Bool>, selection: Binding<Int?>, buttonType: SampleButtons, bank: SampleBank) {
        self._samples = samples
        self._isPlaying = isPlaying
        self._sampleSelection = selection
        self.buttonType = buttonType
        self.bankType = bank
    }
    
    var sampleURL: URL? {
        guard !samples.isEmpty else {return nil}
        return URL(fileURLWithPath: "\(GoXlr.shared.status!.data.status.paths.samplesDirectory)/\(files.samples.first(where: { $0.value == samples[min(samples.count-1, sampleSelection ?? 0)].name})!.key)")
    }
    
    var body: some View {
        GroupBox {
            HStack(spacing: 0) {
                Button(action: {
                    if !isPlaying {
//                                    TODO: use this way instead. requires module fix: on patch of the samplebutton value, indexes are cleared out for some reason
//                                    bank[keyPath: button].samples[sampleSelection ?? 0].play()
                        GoXlr.shared.command(.PlaySampleByIndex(bankType, buttonType, sampleSelection ?? 0))
                    } else {
//                                    bank[keyPath: button].is_playing = false
                        GoXlr.shared.command(.StopSamplePlayback(bankType, buttonType))
                    }
                    
                }, label: {
                    Image(systemName: isPlaying ? "pause" : "play")
                        .padding(1)
                    
                }).buttonStyle(.gentleFilling)
                    .frame(width: 30)
                
                GeometryReader { geo in
                    ZStack {
                        if let url = sampleURL {
                            WaveformView(audioURL: url, configuration: .init(size: geo.size, style: .striped(.init(color: .secondaryLabelColor))))
                                .padding(.horizontal, 7)
                            
                            SampleCropSlidersElement(sampleSelection ?? 0,
                                                     buttonType: buttonType,
                                                     bankType: bankType,
                                                     geometry: geo,
                                                     startPct: $samples[min(samples.count-1, sampleSelection ?? 0)].startPct,
                                                     stopPct: $samples[min(samples.count-1, sampleSelection ?? 0)].stopPct)
                                .clipped()
                        }
                    }
                }
                
                Button(action: {
                    GoXlr.shared.command(.RemoveSampleByIndex(bankType, buttonType, sampleSelection ?? 0))
                    sampleSelection = nil
                }, label: {
                    Image(systemName: "trash")
                        .padding(1)
                }).buttonStyle(.gentleFilling)
                    .frame(width: 30)
            }.disabled(samples.isEmpty)
                .frame(maxHeight: 200)
        }
    }
}
