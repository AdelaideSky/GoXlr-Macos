//
//  SampleCropSliderElement.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 18/06/2023.
//

import SwiftUI
import GoXlrKit
import SkyKit_Design

struct SampleCropSlidersElement: View {
    @State private var isDraggingStart = false
    @State private var isDraggingStop = false
    
    @Binding var startPct: Float
    @Binding var stopPct: Float
    
    @State private var internalStartPct: Float
    @State private var internalStopPct: Float
    
    let geometry: GeometryProxy
    
    var buttonType: SampleButtons
    var bankType: SampleBank
    var index: Int
    
    init(_ index: Int, buttonType: SampleButtons, bankType: SampleBank, geometry: GeometryProxy, startPct: Binding<Float>, stopPct: Binding<Float>) {
        self._startPct = startPct
        self._stopPct = stopPct
        self._internalStartPct = .init(initialValue: startPct.wrappedValue)
        self._internalStopPct = .init(initialValue: stopPct.wrappedValue)
        self.geometry = geometry
        self.buttonType = buttonType
        self.bankType = bankType
        self.index = index
    }
    
    var body: some View {
        ZStack {
            HStack {
                ZStack {
                    SKEffectsView(.hudWindow, blendingMode: .withinWindow)
                    SKNoiseTexture()
                        .opacity(0.05)
                    HStack {
                        Spacer()
                        HStack {
                            Spacer(minLength: 0)
                            Capsule()
                                .frame(width: 3)
                                .padding(.vertical, 50)
                                .padding(.horizontal, 2)
                                .opacity(isDraggingStart ? 0.5 : 0.3)
                        }.frame(width: 5)
                    }
                }.opacity(0.8)
                    .mask {
                        Rectangle()
                            .padding(.leading, 10)
                            .cornerRadius(10)
                            .padding(.leading, -10)
                    }
                    .toggleOnGesture($isDraggingStart)
                    .frame(width: max(5, geometry.size.width * CGFloat(internalStartPct / 100)))
                    .frame(minWidth: 5)
                Spacer()
            }.simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        internalStartPct = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                        if internalStartPct > internalStopPct {
                            internalStopPct = internalStartPct
                        }
                    }
            )
            .onChange(of: stopPct) { newValue in
                internalStopPct = newValue
            }
            .padding(.trailing, 7)
            HStack {
                Spacer()
                ZStack {
                    SKEffectsView(.hudWindow, blendingMode: .withinWindow)
                    SKNoiseTexture()
                        .opacity(0.05)
                    HStack {
                        HStack {
                            Spacer(minLength: 0)
                            Capsule()
                                .frame(width: 3)
                                .padding(.vertical, 50)
                                .padding(.horizontal, 2)
                                .opacity(isDraggingStop ? 0.5 : 0.3)
                            
                        }.frame(width: 5)
                        Spacer()
                    }
                }.opacity(0.8)
                    .mask {
                        Rectangle()
                            .padding(.trailing, 10)
                            .cornerRadius(10)
                            .padding(.trailing, -10)
                    }
                    .toggleOnGesture($isDraggingStop)
                    .frame(width: max(5, geometry.size.width * CGFloat((100-internalStopPct) / 100)))
                    .frame(minWidth: 5)
            }.simultaneousGesture(
                DragGesture(minimumDistance: 0)
                    .onChanged { value in
                        internalStopPct = min(max(0, Float(value.location.x / geometry.size.width * 100)), 100)
                        if internalStartPct > internalStopPct {
                            internalStartPct = internalStopPct
                        }
                    }
            )
            .onChange(of: startPct) { newValue in
                internalStartPct = newValue
            }
            .padding(.leading, 7)
        }.onChange(of: isDraggingStart) { newValue in
            if !newValue {
                GoXlr.shared.command(.SetSampleStartPercent(bankType, buttonType, index, internalStartPct))
            }
        }
        .onChange(of: isDraggingStop) { newValue in
            if !newValue {
                GoXlr.shared.command(.SetSampleStopPercent(bankType, buttonType, index, internalStopPct))
            }
        }
    }
    
}
