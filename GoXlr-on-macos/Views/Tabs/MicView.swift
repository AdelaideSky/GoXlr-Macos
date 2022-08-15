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
    
    @State var slider2: Float = 0 
    

    @Environment(\.colorScheme) var colorScheme
    

    @State private var scaleValue = CGFloat(1)

    @EnvironmentObject var mixer: MixerStatus
    @State var gateExpanded = true
    @State var eqExpanded = false
    @State var compExpanded = false
    
    @State var fineTune = false


    
    var body: some View {
        ZStack {

            VStack {
                HStack(alignment:.top , spacing: 15) {
                    
    //-----------------------------------------------[ Mic status block ]--------------------------------------------------------//

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
    //-----------------------------------------------[ DEESSER Expanded ]-------------------------------------------------------//

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
    //-------------------------------------------------[ COMP Simplified ]--------------------------------------------------------//
                    //Reserving space for comp element that needs to be in other place in order to expand lul
                    RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0)).frame(width: 319, height: 117)
                    
                }
                HStack(alignment:.top , spacing: 15) {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1), radius: 15)

                        VStack {
                            
    //--------------------------------------------------[ NG Expanded ]----------------------------------------------------------//

                            if gateExpanded {
                                HStack {
                                    Text("Noise Gate")
                                        .font(.system(.title2))
                                        .padding(.right, 288)
                                        .frame(alignment: .topLeading)
                                    Button(action: {
                                        mixer.updateMicDetails()
                                        if gateExpanded {
                                            eqExpanded = true
                                            compExpanded = false
                                            gateExpanded.toggle()
                                        }
                                        else {
                                            eqExpanded = false
                                            compExpanded = false
                                            gateExpanded.toggle()
                                        }}) {
                                                Image(systemName: "chevron.right").renderingMode(.original)}
                                        .buttonStyle(.borderless)
                                        .rotationEffect(Angle(degrees: gateExpanded ? 90 : 0))
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
    //--------------------------------------------------[ NG Simplified ]---------------------------------------------------------//

                            else {
                                HStack {
                                    Text("Noise Gate")
                                        .font(.system(.title2))
                                        .frame(alignment: .topLeading)
                                    Button(action: {
                                        mixer.updateMicDetails()
                                        if gateExpanded {
                                            eqExpanded = true
                                            compExpanded = false
                                            gateExpanded.toggle()
                                        }
                                        else {
                                            eqExpanded = false
                                            compExpanded = false
                                            gateExpanded.toggle()
                                        }}) {
                                                Image(systemName: "chevron.right").renderingMode(.original)}
                                        .buttonStyle(.borderless)
                                        .rotationEffect(Angle(degrees: gateExpanded ? 90 : 0))
                                        .animation(.easeInOut, value: 1)
                                }.padding(1)
                                    .padding(.top, 10)
                                HStack {
                                    VStack {
                                        Text("Amount")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        bigVSlider(value: $mixer.gateAmount, in: 0...100, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.gateAmount) { newValue in
                                                mixer.selectedDevice.SetGateAmount(amount: Double(newValue))
                                            }
                                        Text("\(mixer.gateAmount == 0 ? "Off" : String(Int(mixer.gateAmount)))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.bottom, 10)
                                            .padding(.top, 5)

                                    }
                                }
                            }
                        }
                    }.frame(width: gateExpanded ? 416 : 117, height: 320)
                        .animation(.default)
                    
    //--------------------------------------------------[ EQ ]-------------------------------------------------------------------//
                    
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1), radius: 15)

                        VStack {
    //--------------------------------------------------[ EQ Expanded ]----------------------------------------------------------//

                            if eqExpanded {
                                HStack {
                                    Text("Equalizer")
                                        .font(.system(.title2))
                                        .padding(.right, 342)
                                    
                                        .frame(alignment: .topLeading)
                                    Button(action: {
                                        mixer.selectedDevice.ResetEQ()
                                        mixer.updateMicDetails()
                                    }) {
                                        Text("Reset").foregroundColor(.red)
                                    }
                                            
                                    Text("Fine Tune")
                                    Toggle(isOn: $fineTune) {}
                                        .toggleStyle(.switch)
                                        .scaleEffect(0.7)
                                    Button(action: {
                                        mixer.updateMicDetails()

                                        if eqExpanded {
                                            gateExpanded = true
                                            compExpanded = false
                                            eqExpanded.toggle()
                                        }
                                        else {
                                            gateExpanded = false
                                            compExpanded = false
                                            eqExpanded.toggle()
                                        }}) {
                                                Image(systemName: "chevron.right").renderingMode(.original)}
                                        .buttonStyle(.borderless)
                                        .rotationEffect(Angle(degrees: eqExpanded ? 90 : 0))
                                        .animation(.easeInOut, value: 1)
                                }.padding(1)
                                    .padding(.top, 10)
                                
                                
                                HStack {
                                    VStack {
                                        Text(fineTune ? "\(Int(mixer.ft31Hz).hertz())" : "31Hz")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        lightBSLIDER(value: $mixer.eq31Hz, in: -9...9, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.eq31Hz) { newValue in
                                                mixer.selectedDevice.SetEqGain(frequence: .Equalizer31Hz, gain: Int(newValue))
                                            }
                                        
                                        Text("\(Int(mixer.eq31Hz))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                        
                                    }.padding(.bottom, 10)
                                    VStack {
                                        Text(fineTune ? "\(Int(mixer.ft63Hz).hertz())" : "63Hz")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        lightBSLIDER(value: $mixer.eq63Hz, in: -9...9, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.eq63Hz) { newValue in
                                                mixer.selectedDevice.SetEqGain(frequence: .Equalizer63Hz, gain: Int(newValue))
                                            }
                                        
                                        Text("\(Int(mixer.eq63Hz))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                        
                                    }.padding(.bottom, 10)
                                    VStack {
                                        Text(fineTune ? "\(Int(mixer.ft125Hz).hertz())" : "125Hz")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        lightBSLIDER(value: $mixer.eq125Hz, in: -9...9, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.eq125Hz) { newValue in
                                                mixer.selectedDevice.SetEqGain(frequence: .Equalizer125Hz, gain: Int(newValue))
                                            }
                                        
                                        Text("\(Int(mixer.eq125Hz))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                        
                                    }.padding(.bottom, 10)
                                    VStack {
                                        Text(fineTune ? "\(Int(mixer.ft250Hz).hertz())" : "250Hz")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        lightBSLIDER(value: $mixer.eq250Hz, in: -9...9, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.eq250Hz) { newValue in
                                                mixer.selectedDevice.SetEqGain(frequence: .Equalizer250Hz, gain: Int(newValue))
                                            }
                                        
                                        Text("\(Int(mixer.eq250Hz))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                        
                                    }.padding(.bottom, 10)
                                    VStack {
                                        Text(fineTune ? "\(Int(mixer.ft500Hz).hertz())" : "500Hz")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        lightBSLIDER(value: $mixer.eq500Hz, in: -9...9, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.eq500Hz) { newValue in
                                                mixer.selectedDevice.SetEqGain(frequence: .Equalizer500Hz, gain: Int(newValue))
                                            }
                                        
                                        Text("\(Int(mixer.eq500Hz))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                        
                                    }.padding(.bottom, 10)
                                    VStack {
                                        Text(fineTune ? "\(Int(mixer.ft1KHz).hertz())" : "1KHz")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        lightBSLIDER(value: $mixer.eq1KHz, in: -9...9, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.eq1KHz) { newValue in
                                                mixer.selectedDevice.SetEqGain(frequence: .Equalizer1KHz, gain: Int(newValue))
                                            }
                                        
                                        Text("\(Int(mixer.eq1KHz))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                        
                                    }.padding(.bottom, 10)
                                    VStack {
                                        Text(fineTune ? "\(Int(mixer.ft2KHz).hertz())" : "2KHz")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        lightBSLIDER(value: $mixer.eq2KHz, in: -9...9, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.eq2KHz) { newValue in
                                                mixer.selectedDevice.SetEqGain(frequence: .Equalizer2KHz, gain: Int(newValue))
                                            }
                                        
                                        Text("\(Int(mixer.eq2KHz))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                        
                                    }.padding(.bottom, 10)
                                    VStack {
                                        Text(fineTune ? "\(Int(mixer.ft4KHz).hertz())" : "4KHz")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        lightBSLIDER(value: $mixer.eq4KHz, in: -9...9, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.eq4KHz) { newValue in
                                                mixer.selectedDevice.SetEqGain(frequence: .Equalizer4KHz, gain: Int(newValue))
                                            }
                                        
                                        Text("\(Int(mixer.eq4KHz))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                        
                                    }.padding(.bottom, 10)
                                    VStack {
                                        Text(fineTune ? "\(Int(mixer.ft8KHz).hertz())" : "8KHz")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        lightBSLIDER(value: $mixer.eq8KHz, in: -9...9, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.eq8KHz) { newValue in
                                                mixer.selectedDevice.SetEqGain(frequence: .Equalizer8KHz, gain: Int(newValue))
                                            }
                                        
                                        Text("\(Int(mixer.eq8KHz))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                        
                                    }.padding(.bottom, 10)
                                    VStack {
                                        Text(fineTune ? "\(Int(mixer.ft16KHz).hertz())" : "16KHz")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        lightBSLIDER(value: $mixer.eq16KHz, in: -9...9, display: "", textsize: 11).padding(.top, 10)
                                            .onChange(of: mixer.eq16KHz) { newValue in
                                                mixer.selectedDevice.SetEqGain(frequence: .Equalizer16KHz, gain: Int(newValue))
                                            }
                                        
                                        Text("\(Int(mixer.eq16KHz))")
                                            .font(.system(.body))
                                            .foregroundColor(.gray)
                                            .padding(.top, 5)
                                        
                                    }.padding(.bottom, 10)
                                }
                                
    //--------------------------------------------------[ FineTune Activated ]---------------------------------------------------------//

                                if fineTune {
                                    HStack {
                                        Slider(value: $mixer.ft31Hz, in: 300...18000)
                                            .scaleEffect(0.9)
                                            .controlSize(.mini)
                                            .onChange(of: mixer.ft31Hz) { newValue in
                                                mixer.selectedDevice.SetEqFreq(frequence: .Equalizer31Hz, freq: Float32(newValue))
                                            }
                                        Slider(value: $mixer.ft63Hz, in: 300...18000)
                                            .scaleEffect(0.9)
                                            .controlSize(.mini)
                                            .onChange(of: mixer.ft63Hz) { newValue in
                                                mixer.selectedDevice.SetEqFreq(frequence: .Equalizer63Hz, freq: Float32(newValue))
                                            }
                                        Slider(value: $mixer.ft125Hz, in: 300...18000)
                                            .scaleEffect(0.9)
                                            .controlSize(.mini)
                                            .onChange(of: mixer.ft125Hz) { newValue in
                                                mixer.selectedDevice.SetEqFreq(frequence: .Equalizer125Hz, freq: Float32(newValue))
                                            }
                                        Slider(value: $mixer.ft250Hz, in: 300...18000)
                                            .scaleEffect(0.9)
                                            .controlSize(.mini)
                                            .onChange(of: mixer.ft250Hz) { newValue in
                                                mixer.selectedDevice.SetEqFreq(frequence: .Equalizer250Hz, freq: Float32(newValue))
                                            }
                                        Slider(value: $mixer.ft500Hz, in: 300...18000)
                                            .scaleEffect(0.9)
                                            .controlSize(.mini)
                                            .onChange(of: mixer.ft500Hz) { newValue in
                                                mixer.selectedDevice.SetEqFreq(frequence: .Equalizer500Hz, freq: Float32(newValue))
                                            }
                                        Slider(value: $mixer.ft1KHz, in: 300...18000)
                                            .scaleEffect(0.9)
                                            .controlSize(.mini)
                                            .onChange(of: mixer.ft1KHz) { newValue in
                                                mixer.selectedDevice.SetEqFreq(frequence: .Equalizer1KHz, freq: Float32(newValue))
                                            }
                                        Slider(value: $mixer.ft2KHz, in: 300...18000)
                                            .scaleEffect(0.9)
                                            .controlSize(.mini)
                                            .onChange(of: mixer.ft2KHz) { newValue in
                                                mixer.selectedDevice.SetEqFreq(frequence: .Equalizer2KHz, freq: Float32(newValue))
                                            }
                                        Slider(value: $mixer.ft4KHz, in: 300...18000)
                                            .scaleEffect(0.9)
                                            .controlSize(.mini)
                                            .onChange(of: mixer.ft4KHz) { newValue in
                                                mixer.selectedDevice.SetEqFreq(frequence: .Equalizer4KHz, freq: Float32(newValue))
                                            }
                                        Slider(value: $mixer.ft8KHz, in: 300...18000)
                                            .scaleEffect(0.9)
                                            .controlSize(.mini)
                                            .onChange(of: mixer.ft8KHz) { newValue in
                                                mixer.selectedDevice.SetEqFreq(frequence: .Equalizer8KHz, freq: Float32(newValue))
                                            }
                                        Slider(value: $mixer.ft16KHz, in: 300...18000)
                                            .scaleEffect(0.9)
                                            .controlSize(.mini)
                                            .onChange(of: mixer.ft16KHz) { newValue in
                                                mixer.selectedDevice.SetEqFreq(frequence: .Equalizer16KHz, freq: Float32(newValue))
                                            }
                                    }.padding(.bottom)
                                        
                                }
    //--------------------------------------------------[ EQ Simplified ]---------------------------------------------------------//

                            } else {
                                HStack {
                                    Text("Equalizer")
                                        .font(.system(.title2))
                                        .padding(.right, compExpanded ? 160 : 200)
                                    
                                        .frame(alignment: .topLeading)
                                    Button(action: {
                                        mixer.updateMicDetails()

                                        if eqExpanded {
                                            gateExpanded = true
                                            compExpanded = false
                                            eqExpanded.toggle()
                                        }
                                        else {
                                            gateExpanded = false
                                            compExpanded = false
                                            eqExpanded.toggle()
                                        }}) {
                                                Image(systemName: "chevron.right").renderingMode(.original)}
                                        .buttonStyle(.borderless)
                                        .rotationEffect(Angle(degrees: eqExpanded ? 90 : 0))
                                        .animation(.easeInOut, value: 1)
                                }.padding(1)
                                    .padding(.top, 10)
                                
                                HStack {
                                    VStack {
                                        Text("Bass")
                                            .font(.system(.subheadline))
                                            .padding(.top, 10)
                                        bigVSlider(value: $mixer.eqBass, in: -9...9, display: "", textsize: 11).padding(.top, 10)
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
                                        bigVSlider(value: $mixer.eqMid, in: -9...9, display: "", textsize: 11).padding(.top, 10)
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
                                        bigVSlider(value: $mixer.eqTremble, in: -9...9, display: "", textsize: 10).padding(.top, 10)
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
                        }
                    }.frame(width: compExpanded ? (286) : (eqExpanded ? 620 : 317), height: 320)
                    if compExpanded {
                        //Reserving space for comp element that needs to be in other place in order to expand lul
                        RoundedRectangle(cornerRadius: 10).fill(.white.opacity(0)).frame(width: 319, height: 117)
                    }
                }
        }
            
            ZStack() {
                RoundedRectangle(cornerRadius: 10).fill(.background)
                    .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)

//-------------------------------------------------[ COMP Expanded ]--------------------------------------------------------//

                if compExpanded {
                    VStack {
                        HStack {
                            Text("Compressor")
                                .font(.system(.title2))
                                .padding(.right, 180)
                                .frame(alignment: .topLeading)
                            Button(action: {
                                mixer.updateMicDetails()
                                if compExpanded {
                                    eqExpanded = false
                                    gateExpanded = true
                                    compExpanded.toggle()
                                }
                                else {
                                    eqExpanded = false
                                    gateExpanded = false
                                    gateExpanded.toggle()
                                }}) {
                                        Image(systemName: "chevron.right").renderingMode(.original)}
                                .buttonStyle(.borderless)
                                .rotationEffect(Angle(degrees: compExpanded ? 90 : 0))
                                .animation(.easeInOut, value: 1)
                        }.padding(.bottom, 41)
                            .padding(.top, 12)
                        Text("Make-up gain")
                            .font(.system(.subheadline))
                            .padding(.left, 20)
                        HStack {
                            Text("\(Int(mixer.compMakeUpGain))dB")
                                .font(.system(.body))
                                .foregroundColor(.gray)
                                .padding(.bottom, 3)
                            makupGainSlider(percentage: $mixer.compMakeUpGain)
                                .onChange(of: mixer.compMakeUpGain) { newValue in
                                    mixer.selectedDevice.SetCompressorMakeupGain(gain: Int(newValue))
                                }
                            
                        }.padding(.left)
                            .padding(.right)
                            .padding(.bottom, 30)
                        
                        HStack {
                            VStack {
                                Text("Threshold")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                lightBSLIDER(value: $mixer.compThreshold, in: -40...0, display: "", textsize: 11).padding(.top, 10)
                                    .onChange(of: mixer.compThreshold) { newValue in
                                        mixer.selectedDevice.SetCompressorThreshold(treshold: Int(newValue))
                                    }
                                
                                Text("\(Int(mixer.compThreshold))dB")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                                
                            }.padding(.bottom, 10)
                            
                            VStack {
                                Text("Ratio")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                lightBSLIDER(value: $mixer.compRatio, in: 0...14, display: "", textsize: 11).padding(.top, 10)
                                    .onChange(of: mixer.compRatio) { newValue in
                                        mixer.selectedDevice.SetCompressorRatio(ratio: Int(newValue).GetCompRatio())
                                    }
                                
                                Text("\(Int(mixer.compRatio).GetCompRatio().humanReadable())")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                                
                            }.padding(.bottom, 10)
                            VStack {
                                Text("Attack")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                lightBSLIDER(value: $mixer.compAttack, in: 0...40, display: "", textsize: 11).padding(.top, 10)
                                    .onChange(of: mixer.compAttack) { newValue in
                                        mixer.selectedDevice.SetCompressorAttack(attack: Int(newValue).GetClosestAtkCompTime())
                                    }
                                
                                Text("\(Int(mixer.compAttack))ms")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                                
                            }.padding(.bottom, 10)
                            VStack {
                                Text("Release")
                                    .font(.system(.subheadline))
                                    .padding(.top, 10)
                                lightBSLIDER(value: $mixer.compRelease, in: 0...3000, display: "", textsize: 11).padding(.top, 10)
                                    .onChange(of: mixer.compRelease) { newValue in
                                        mixer.selectedDevice.SetCompressorReleaseTime(release: Int(newValue).GetClosestRelCompTime())
                                    }
                                
                                Text("\(Int(mixer.compRelease))ms")
                                    .font(.system(.body))
                                    .foregroundColor(.gray)
                                    .padding(.top, 5)
                                
                            }.padding(.bottom, 10)
                        }
                        
                    }.padding(1)
                        .padding(.top, 5)
                    
//-------------------------------------------------[ COMP Simplified ]--------------------------------------------------------//

                } else {
                    VStack {
                        HStack {
                            Text("Compressor")
                                .font(.system(.title2))
                                .padding(.right, 180)
                                .frame(alignment: .topLeading)
                            Button(action: {
                                mixer.updateMicDetails()
                                if compExpanded {
                                    eqExpanded = false
                                    gateExpanded = true
                                    compExpanded.toggle()
                                }
                                else {
                                    eqExpanded = false
                                    gateExpanded = false
                                    compExpanded.toggle()
                                }}) {
                                        Image(systemName: "chevron.right").renderingMode(.original)}
                                .buttonStyle(.borderless)
                                .rotationEffect(Angle(degrees: compExpanded ? 90 : 0))
                                .animation(.easeInOut, value: 1)
                        }
                        HStack {
                            Text("\(Int(mixer.compAmount))")
                                .font(.system(.body))
                                .foregroundColor(.gray)
                                .padding(.bottom, 3)
                            BigSurSlider(percentage: $mixer.compAmount)
                                .onChange(of: mixer.compAmount) { newValue in
                                    mixer.selectedDevice.SetCompressorAmount(amount: Int(newValue))
                                }
                        }.padding()
                        
                    }.padding(1)
                        .padding(.top, 5)
                }
            }.frame(width: 319, height: compExpanded ? 450 : 117)
                .padding(.left, 433)
                .padding(.bottom, compExpanded ? 1 : 330)
        
            

        }.navigationTitle(tabname!)
            .animation(.default)
            .onAppear(perform: mixer.updateMicDetails)
            .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab: "mic").environmentObject(mixer)})
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {mixer.profileSheet.toggle()}, label: {
                        Text("Load Profile")
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {MixerStatus().selectedDevice.SaveMicProfile()}, label: {
                        Text("Save Mic Profile")
                    })
                }
            }

    }
}
