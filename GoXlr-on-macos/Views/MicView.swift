//
//  MicView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 20/07/2022.
//

extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double((hex & 0xff) >> 0) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}

import SwiftUI

struct MicView: View {
    @State var tabname: String? = "Microphone"
    @State var slider: Float = 0
    @State var slider2: Float = 0
    @State var rotation: Double = 0
    @State var rotation2: Double = 90
    @Environment(\.colorScheme) var colorScheme
    

    @State private var scaleValue = CGFloat(1)

    @EnvironmentObject var mixer: MixerStatus


    
    var body: some View {
        
        VStack {
            HStack(alignment:.top , spacing: 15) {
                ZStack() {
                    RoundedRectangle(cornerRadius: 10).fill(.background)
                        .frame(width: 117, height: 117)
                        .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)

                    VStack {
                        Text("Microphone type")
                            .font(.system(.footnote))
                        Text(mixer.micType.rawValue).padding()
                            .font(.system(.title2))
                        Text("\(Int(mixer.activeGain)) dB")
                            .font(.system(.body))
                            .foregroundColor(.gray)
                        
                    }
                }
                .scaleEffect(self.scaleValue)
                .onTouchGesture(
                    touchBegan: { withAnimation(.easeInOut(duration: 0.01)) { self.scaleValue = 0.98 } },
                    touchEnd: { _ in withAnimation(.easeInOut(duration: 0.01)) { self.scaleValue = 1.0 }
                        mixer.micSetup = true
                    }
                )
                
                .sheet(isPresented: $mixer.micSetup, content: {MicSetupView().environmentObject(mixer)})
                ZStack() {
                    RoundedRectangle(cornerRadius: 10).fill(.background)
                        .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                    VStack {
                        Text("De-esser")
                            .font(.system(.title2))
                            .padding(.right, 190)
                            .frame(alignment: .topLeading)
                        HStack {
                            Text("\(Int(mixer.deEsser))")
                                .font(.system(.body))
                                .foregroundColor(.gray)
                                .padding(.bottom, 3)
                            BigSurSlider(percentage: $mixer.deEsser)
                                .onChange(of: mixer.deEsser) { newValue in
                                    mixer.selectedDevice.SetDeEsser(amount: Int(newValue))
                                }
                        }.padding()
                    }.padding(1)
                        .padding(.top, 5)
                }.frame(width: 286, height: 117)
                
                ZStack() {
                    RoundedRectangle(cornerRadius: 10).fill(.background)
                        .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                    VStack {
                        HStack {
                            Text("Compressor")
                                .font(.system(.title2))
                                .padding(.right, 180)
                                .frame(alignment: .topLeading)
                            Button(action: {print("button pressed")
                                if rotation == 0 {rotation = 90}
                                else {rotation = 0}}) {
                                        Image(systemName: "chevron.right").renderingMode(.original)}
                                .buttonStyle(.borderless)
                                .rotationEffect(Angle(degrees: rotation))
                                .animation(.easeInOut, value: 1)
                        }
                        HStack {
                            Text("\(Int(slider2))")
                                .font(.system(.body))
                                .foregroundColor(.gray)
                                .padding(.bottom, 3)
                            BigSurSlider(percentage: $slider2)
                                .onChange(of: slider2) { newValue in
                                }
                        }.padding()
                        
                    }.padding(1)
                        .padding(.top, 5)
                }.frame(width: 319, height: 117)
            }
            HStack(alignment:.top , spacing: 15) {
                ZStack() {
                    RoundedRectangle(cornerRadius: 10).fill(.background)
                        .shadow(color:Color(hex: 000000, opacity: 0.1), radius: 15)

                    VStack {
                        HStack {
                            Text("Noise Gate")
                                .font(.system(.title2))
                                .padding(.right, 288)
                                .frame(alignment: .topLeading)
                            Button(action: {print("button pressed")
                                if rotation2 == 0 {rotation2 = 90}
                                else {rotation2 = 0}}) {
                                        Image(systemName: "chevron.right").renderingMode(.original)}
                                .buttonStyle(.borderless)
                                .rotationEffect(Angle(degrees: rotation2))
                                .animation(.easeInOut, value: 1)
                        }.padding(1)
                            .padding(.top, 10)
                        
                        HStack {
                            VStack {
                                Text("Threshold")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                bigVSlider(value: $mixer.gateThreshold, in: -59...0, display: "", textsize: 11).padding(.top, 10)
                                    .onChange(of: mixer.gateThreshold) { newValue in
                                        mixer.selectedDevice.SetGateThreshold(treshold: Int(newValue))
                                    }
                                Text("\(Int(mixer.gateThreshold)) dB")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 10)
                                    .padding(.top, 5)

                            }
                            VStack {
                                Text("Attenuation")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                bigVSlider(value: $mixer.gateAttenuation, in: 0...100, display: "", textsize: 11).padding(.top, 10)
                                    .onChange(of: mixer.gateAttenuation) { newValue in
                                        mixer.selectedDevice.SetGateAttenuation(attenuation: Int(newValue))
                                    }
                                Text("\(Int(mixer.gateAttenuation)) %")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 10)
                                    .padding(.top, 5)

                            }
                            VStack {
                                Text("Attack")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                bigVSlider(value: $mixer.gateAttack, in: 10...2000, display: "", textsize: 9).padding(.top, 10)
                                    .onChange(of: mixer.gateAttack) { newValue in
                                        mixer.selectedDevice.SetGateAttack(attack: Int(newValue).GetClosestGateTime())
                                    }
                                    
                                Text("\(Int(mixer.gateAttack)) ms")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 10)
                                    .padding(.top, 5)
                            }
                            VStack {
                                Text("Release")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                bigVSlider(value: $mixer.gateRelease, in: 10...2000, display: "", textsize: 10).padding(.top, 10)
                                    .onChange(of: mixer.gateRelease) { newValue in
                                        mixer.selectedDevice.SetGateRelease(release: Int(newValue).GetClosestGateTime())
                                    }
                                Text("\(Int(mixer.gateRelease)) ms")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.bottom, 10)
                                    .padding(.top, 5)

                            }
                        }
                    }
                }.frame(width: 416, height: 320)
                ZStack() {
                    RoundedRectangle(cornerRadius: 10).fill(.background)
                        .shadow(color:Color(hex: 000000, opacity: 0.1), radius: 15)

                    VStack {
                        HStack {
                            Text("Equalizer")
                                .font(.system(.title2))
                                .padding(.right, 200)
                            
                                .frame(alignment: .topLeading)
                            Button(action: {print("button pressed")
                                if rotation2 == 0 {rotation2 = 90}
                                else {rotation2 = 0}}) {
                                        Image(systemName: "chevron.right").renderingMode(.original)}
                                .buttonStyle(.borderless)
                                .rotationEffect(Angle(degrees: rotation2))
                                .animation(.easeInOut, value: 1)
                        }.padding(1)
                            .padding(.top, 10)
                        
                        HStack {
                            VStack {
                                Text("Bass")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                bigVSlider(value: $mixer.eqBass, in: -9...9, display: String(Int(mixer.eqBass)), textsize: 11).padding(.top, 10)
                                    .onChange(of: mixer.eqBass) { newValue in
                                        mixer.selectedDevice.setSimplifiedEq(type: .Bass, value: Int(newValue))
                                    }
                                
                                Text("\(Int(mixer.eqBass))")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                                
                            }.padding(.bottom, 10)
                            VStack {
                                Text("Mid")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                bigVSlider(value: $mixer.eqMid, in: -9...9, display: String(Int(mixer.eqMid)), textsize: 11).padding(.top, 10)
                                    .onChange(of: mixer.eqMid) { newValue in
                                        mixer.selectedDevice.setSimplifiedEq(type: .Mid, value: Int(newValue))
                                    }
                                Text("\(Int(mixer.eqMid))")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                            }.padding(.bottom, 10)
                            VStack {
                                Text("Tremble")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                bigVSlider(value: $mixer.eqTremble, in: -9...9, display: String(Int(mixer.eqTremble)), textsize: 10).padding(.top, 10)
                                    .onChange(of: mixer.eqTremble) { newValue in
                                        mixer.selectedDevice.setSimplifiedEq(type: .Tremble, value: Int(newValue))
                                    }
                                Text("\(Int(mixer.eqTremble))")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                            }.padding(.bottom, 10)
                            
                        }
                    }
                }.frame(width: 317, height: 320)
                                    
            }
            

        }.navigationTitle(tabname!)
            .onAppear(perform: mixer.updateMicDetails)
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {}, label: {
                        Text("Load Mic Profile")
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {mixer.selectedDevice.SaveMicProfile()}, label: {
                        Text("Save Mic Profile")
                    })
                }
            }
    }
}
