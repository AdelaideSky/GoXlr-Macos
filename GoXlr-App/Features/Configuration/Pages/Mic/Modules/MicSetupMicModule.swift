//
//  MicSetupMicModule.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 20/04/2023.
//

import SwiftUI
import GoXlrKit
import GoXlrKit_Audio
import Colorful
import SkyKit_Design
import AVFoundation

struct MicSetupMicModule: View {
    @State var showingMicSetupSheet = false
    
    var body: some View {
        Section("Mic Setup") {
            VStack {
                Button(action: {
                    showingMicSetupSheet.toggle()
                }, label: {
                    VStack {
                        Image(systemName: "mic")
                            .font(.system(size: 50))
                            .padding(.horizontal)
                            .padding(.bottom)
                        Text("Mic Setup")
                            .font(.title3)
                    }.padding()
                }).buttonStyle(.gentleFilling)
                    .frame(maxHeight: 100)
                    .padding()
                    .padding(.vertical, 10)
            }
        }.sheet(isPresented: $showingMicSetupSheet) {
            MicSetupView($showingMicSetupSheet)
        }
    }
}

struct MicSetupView: View {
    @Binding var isPresented: Bool
    @State var captureSession: AVCaptureSession?
    @State var timer: Timer?
    @State var level: Float = 0
    @ObservedObject var mic = GoXlr.shared.mixer!.micStatus
    
    init(_ isPresented: Binding<Bool>) {
        self._isPresented = isPresented
    }
    
    var body: some View {
        HStack {
            VStack {
                List(selection: $mic.micType) {
                    Section("Mic type") {
                        Text("Dynamic").tag(MicrophoneType.Dynamic)
                        Text("Condenser").tag(MicrophoneType.Condenser)
                        Text("3.5mm").tag(MicrophoneType.Jack)
                    }
                }.listStyle(.sidebar)
                Spacer()
                Button("Done", role: .cancel) {
                    timer?.invalidate()
                    captureSession?.stopRunning()
                    isPresented.toggle()
                }
                    .buttonStyle(.gentleFilling)
                    .frame(height: 25)
                    .padding(.vertical)
                    .padding(.horizontal, 6)
                    .padding(.leading, 4)
            }.frame(width: 100)
            Divider()
            GroupBox {
                Group {
                    switch mic.micType {
                    case .Dynamic:
                        LabelledVSliderElement(label: "Gain", value: $mic.micGains.micGainsDynamic, range: 0...72, sliderWidth: 20, sliderHeight: 230, unity: "dB")
                    case .Condenser:
                        LabelledVSliderElement(label: "Gain", value: $mic.micGains.condenser, range: 0...72, sliderWidth: 20, sliderHeight: 230, unity: "dB")
                    case .Jack:
                        LabelledVSliderElement(label: "Gain", value: $mic.micGains.jack, range: 0...72, sliderWidth: 20, sliderHeight: 230, unity: "dB")
                    }
                }.frame(width: 50)
            }
                .padding(.leading, 20)
            GroupBox {
                Text(" Mic Meter ").font(.system(.subheadline))
                VStack {
                    Group {
                        if timer != nil {
                            MeterView(level: $level)
                            
                        } else {
                            VStack {
                                Spacer()
                                ProgressView()
                                    .scaleEffect(0.5)
                                    .opacity(0.8)
                                Spacer()
                            }
                        }
                            
                    }.frame(width: 20)
                        .padding()
                }
            }.padding()
                .padding(.vertical, 3)
                .padding(.leading)
                .padding(.trailing, 10)
        }.frame(width: 330, height: 350)
            .task() {
                captureSession = GoXlrAudio.shared.createSession()
                captureSession!.startRunning()
                timer = Timer.scheduledTimer(withTimeInterval: 0.01, repeats: true, block: { _ in
                    //22
                    Task { @MainActor in
                        let tmplevel = (captureSession!.outputs.first?.connections.first?.audioChannels[1].averagePowerLevel)! + 5
                        level = max(-40, tmplevel)
                    }
                })
            }
    }
}
struct MeterView: View {
    @Binding var level: Float
    
    init(level: Binding<Float>) {
        self._level = level
    }
    
    var body: some View {
        
        ZStack {
            RoundedRectangle(cornerRadius: 4)
                .fill(.secondary)
                .opacity(0.1)
            GeometryReader { geo in
                RoundedRectangle(cornerRadius: 4)
                    .fill(Gradient(colors: [.init(hex: "C02F20"), .init(hex: "348E56"), .init(hex: "98C26F"), .init(hex: "F7EEA3")]))
                    .overlay {
                        SKNoiseTexture()
                            .opacity(0.1)
                    }
                    .mask {
                        VStack {
                            Spacer()
                            RoundedRectangle(cornerRadius: 4)
                                .frame(height: geo.size.height*(1+(-Double(level/(-40)))))
                        }
                    }
                    .shadow(color: .red, radius: (1+(-Double(max(-8, level)/(-8))))*20)
                
            }
        }
    }
}
