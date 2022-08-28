//
//  MixerLightningView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 01/08/2022.
//

import Foundation
import SwiftUI

struct MixerLightningView: View {
    @State var tabname: String? = "Mixer Lightning"
    @EnvironmentObject var mixer: MixerStatus
    
    let listFaders: [FadersLightning] = [.All, .A, .B, .C, .D]
    @State private var selectedFader: FadersLightning = .All
    
    @State private var toggle1 = false
    @State private var toggle2 = true


    var body: some View {
        VStack(alignment: .center) {
            HStack {
                if selectedFader == .All {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        VStack {
                            Text("Screen")
                                .font(.system(.title2))
                                .padding(.right, 160)
                                .padding(.bottom, 430)
                                .frame(alignment: .topLeading)
                        }
                        
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Fader")
                                .font(.system(.title2))
                                .padding(.right, 160)
                                .padding(.bottom, 1)
                                .frame(alignment: .topLeading)
                            
                            Group {
                                Text("Style")
                                    .padding(.top, 3)
                                    .padding(.bottom, 1)
                                    .opacity(0.8)
                                    .font(.system(.headline))
                                Picker("", selection: $mixer.styleFaderA){
                                    Text("Two colour").tag(FaderDisplayStyle.TwoColour)
                                    Text("Gradient").tag(FaderDisplayStyle.Gradient)
                                    
                                    Text("Meter").tag(FaderDisplayStyle.Meter)
                                    Text("Gradient meter").tag(FaderDisplayStyle.GradientMeter)
                                }.padding(.horizontal, 30)
                                    .onChange(of: mixer.styleFaderA) { newValue in
                                        mixer.selectedDevice.SetFaderDisplayStyle(faderName: .All, displayStyle: newValue)
                                    }
                                    .padding(.bottom, 3)
                                
                                Divider().padding(.vertical, 3)
                                    .opacity(0.6)
                            }
                            
                            ColourWheel(radius: 110, rgbColour: $mixer.topFaderA, brightness: $mixer.brTopFaderA)
                            CustomSlider(rgbColour: $mixer.topFaderA, value: $mixer.brTopFaderA, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.topFaderA.onChangeCompatible(br:mixer.brTopFaderA)) { newValue in

                                    mixer.selectedDevice.SetFaderColours(faderName: mixer.lightningFadersSelected, colourTop: mixer.topFaderA.rgb.toHex(), colourBottom: mixer.bottomFaderA.rgb.toHex())
                                }
                            Text("Top")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))
                            
                            Divider().padding(.vertical, 3)
                                .opacity(0.6)

                            ColourWheel(radius: 110, rgbColour: $mixer.bottomFaderA, brightness: $mixer.brBottomFaderA)
                            CustomSlider(rgbColour: $mixer.bottomFaderA, value: $mixer.brBottomFaderA, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.bottomFaderA.onChangeCompatible(br:mixer.brBottomFaderA)) { newValue in
                                   
                                    mixer.selectedDevice.SetFaderColours(faderName: mixer.lightningFadersSelected, colourTop: mixer.topFaderA.rgb.toHex(), colourBottom: mixer.bottomFaderA.rgb.toHex())

                                }
                            Text("Bottom")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))

                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                    
                    
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Mute button")
                                .font(.system(.title2))
                                .padding(.right, 110)
                                .padding(.bottom, 1)
                                .frame(alignment: .topLeading)
                            
                            Group {
                                Text("Off option")
                                    .padding(.top, 3)
                                    .padding(.bottom, 1)
                                    .opacity(0.8)
                                    .font(.system(.headline))
                                Picker("", selection: $mixer.buttonMuteAStyle){
                                    Text("Dimmed colour 1").tag(ButtonColourOffStyle.Dimmed)
                                    Text("Colour 2").tag(ButtonColourOffStyle.Colour2)
                                    Text("Dimmed colour 2").tag(ButtonColourOffStyle.DimmedColour2)
                                }.padding(.horizontal, 30)
                                    .onChange(of: mixer.buttonMuteAStyle) { newValue in
                                        mixer.selectedDevice.SetButtonGroupOffStyle(group: .FaderMute, style: newValue)
                                    }
                                    .padding(.bottom, 3)
                                
                                Divider().padding(.vertical, 3)
                                    .opacity(0.6)
                            }
                            
                            ColourWheel(radius: 110, rgbColour: $mixer.buttonMuteAColour1, brightness: $mixer.brButtonMuteAColour1)
                            CustomSlider(rgbColour: $mixer.buttonMuteAColour1, value: $mixer.brButtonMuteAColour1, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.buttonMuteAColour1.onChangeCompatible(br:mixer.brButtonMuteAColour1)) { newValue in
                                    mixer.selectedDevice.SetButtonGroupColours(group: .FaderMute, colour1: mixer.buttonMuteAColour1.rgb.toHex(), colour2: mixer.buttonMuteAColour2.rgb.toHex())
                                }
                            Text("Colour 1")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))
                            
                            Divider().padding(.vertical, 3)
                                .opacity(0.6)

                            ColourWheel(radius: 110, rgbColour: $mixer.buttonMuteAColour2, brightness: $mixer.brButtonMuteAColour2)
                            CustomSlider(rgbColour: $mixer.buttonMuteAColour2, value: $mixer.brButtonMuteAColour2, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.buttonMuteAColour2.onChangeCompatible(br:mixer.brButtonMuteAColour2)) { newValue in
                                    mixer.selectedDevice.SetButtonGroupColours(group: .FaderMute, colour1: mixer.buttonMuteAColour1.rgb.toHex(), colour2: mixer.buttonMuteAColour2.rgb.toHex())
                                }
                            Text("Colour 2")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))

                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                }
                else if selectedFader == .A {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        VStack {
                            Text("Screen")
                                .font(.system(.title2))
                                .padding(.right, 160)
                                .padding(.bottom, 430)
                                .frame(alignment: .topLeading)
                        }
                        
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Fader")
                                .font(.system(.title2))
                                .padding(.right, 160)
                                .padding(.bottom, 1)
                                .frame(alignment: .topLeading)
                            
                            Group {
                                Text("Style")
                                    .padding(.top, 3)
                                    .padding(.bottom, 1)
                                    .opacity(0.8)
                                    .font(.system(.headline))
                                Picker("", selection: $mixer.styleFaderA){
                                    Text("Two colour").tag(FaderDisplayStyle.TwoColour)
                                    Text("Gradient").tag(FaderDisplayStyle.Gradient)
                                    
                                    Text("Meter").tag(FaderDisplayStyle.Meter)
                                    Text("Gradient meter").tag(FaderDisplayStyle.GradientMeter)
                                }.padding(.horizontal, 30)
                                    .onChange(of: mixer.styleFaderA) { newValue in
                                        mixer.selectedDevice.SetFaderDisplayStyle(faderName: .A, displayStyle: newValue)
                                    }
                                    .padding(.bottom, 3)
                                
                                Divider().padding(.vertical, 3)
                                    .opacity(0.6)
                            }
                            
                            ColourWheel(radius: 110, rgbColour: $mixer.topFaderA, brightness: $mixer.brTopFaderA)
                            CustomSlider(rgbColour: $mixer.topFaderA, value: $mixer.brTopFaderA, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.topFaderA.onChangeCompatible(br:mixer.brTopFaderA)) { newValue in

                                    mixer.selectedDevice.SetFaderColours(faderName: selectedFader, colourTop: mixer.topFaderA.rgb.toHex(), colourBottom: mixer.bottomFaderA.rgb.toHex())
                                }
                            Text("Top")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))
                            
                            Divider().padding(.vertical, 3)
                                .opacity(0.6)

                            ColourWheel(radius: 110, rgbColour: $mixer.bottomFaderA, brightness: $mixer.brBottomFaderA)
                            CustomSlider(rgbColour: $mixer.bottomFaderA, value: $mixer.brBottomFaderA, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.bottomFaderA.onChangeCompatible(br:mixer.brBottomFaderA)) { newValue in
                                   
                                    mixer.selectedDevice.SetFaderColours(faderName: selectedFader, colourTop: mixer.topFaderA.rgb.toHex(), colourBottom: mixer.bottomFaderA.rgb.toHex())

                                }
                            Text("Bottom")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))

                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                    
                    
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Mute button")
                                .font(.system(.title2))
                                .padding(.right, 110)
                                .padding(.bottom, 1)
                                .frame(alignment: .topLeading)
                            
                            Group {
                                Text("Off option")
                                    .padding(.top, 3)
                                    .padding(.bottom, 1)
                                    .opacity(0.8)
                                    .font(.system(.headline))
                                Picker("", selection: $mixer.buttonMuteAStyle){
                                    Text("Dimmed colour 1").tag(ButtonColourOffStyle.Dimmed)
                                    Text("Colour 2").tag(ButtonColourOffStyle.Colour2)
                                    Text("Dimmed colour 2").tag(ButtonColourOffStyle.DimmedColour2)
                                }.padding(.horizontal, 30)
                                    .onChange(of: mixer.buttonMuteAStyle) { newValue in
                                        mixer.selectedDevice.SetButtonOffStyle(button: .Fader1Mute, style: newValue)
                                    }
                                    .padding(.bottom, 3)
                                
                                Divider().padding(.vertical, 3)
                                    .opacity(0.6)
                            }
                            
                            ColourWheel(radius: 110, rgbColour: $mixer.buttonMuteAColour1, brightness: $mixer.brButtonMuteAColour1)
                            CustomSlider(rgbColour: $mixer.buttonMuteAColour1, value: $mixer.brButtonMuteAColour1, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.buttonMuteAColour1.onChangeCompatible(br:mixer.brButtonMuteAColour1)) { newValue in
                                    mixer.selectedDevice.SetButtonColours(button: .Fader1Mute, colour1: mixer.buttonMuteAColour1.rgb.toHex(), colour2: mixer.buttonMuteAColour2.rgb.toHex())
                                }
                            Text("Colour 1")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))
                            
                            Divider().padding(.vertical, 3)
                                .opacity(0.6)

                            ColourWheel(radius: 110, rgbColour: $mixer.buttonMuteAColour2, brightness: $mixer.brButtonMuteAColour2)
                            CustomSlider(rgbColour: $mixer.buttonMuteAColour2, value: $mixer.brButtonMuteAColour2, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.buttonMuteAColour2.onChangeCompatible(br:mixer.brButtonMuteAColour2)) { newValue in
                                    mixer.selectedDevice.SetButtonGroupColours(group: .FaderMute, colour1: mixer.buttonMuteAColour1.rgb.toHex(), colour2: mixer.buttonMuteAColour2.rgb.toHex())
                                }
                            Text("Colour 2")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))

                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                }
                else if selectedFader == .B {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Screen")
                                .font(.system(.title2))
                                .padding(.right, 160)
                                .padding(.bottom, 430)
                                .frame(alignment: .topLeading)
                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Fader")
                                .font(.system(.title2))
                                .padding(.right, 160)
                                .padding(.bottom, 1)
                                .frame(alignment: .topLeading)
                            
                            Group {
                                Text("Style")
                                    .padding(.top, 3)
                                    .padding(.bottom, 1)
                                    .opacity(0.8)
                                    .font(.system(.headline))
                                Picker("", selection: $mixer.styleFaderB){
                                    Text("Two colour").tag(FaderDisplayStyle.TwoColour)
                                    Text("Gradient").tag(FaderDisplayStyle.Gradient)
                                    
                                    Text("Meter").tag(FaderDisplayStyle.Meter)
                                    Text("Gradient meter").tag(FaderDisplayStyle.GradientMeter)
                                }.padding(.horizontal, 30)
                                    .onChange(of: mixer.styleFaderB) { newValue in
                                        mixer.selectedDevice.SetFaderDisplayStyle(faderName: .B, displayStyle: newValue)
                                    }
                                    .padding(.bottom, 3)
                                
                                Divider().padding(.vertical, 3)
                                    .opacity(0.6)
                            }
                            
                            ColourWheel(radius: 110, rgbColour: $mixer.topFaderB, brightness: $mixer.brTopFaderB)
                            CustomSlider(rgbColour: $mixer.topFaderB, value: $mixer.brTopFaderB, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.topFaderB.onChangeCompatible(br:mixer.brTopFaderB)) { newValue in

                                    mixer.selectedDevice.SetFaderColours(faderName: selectedFader, colourTop: mixer.topFaderB.rgb.toHex(), colourBottom: mixer.bottomFaderB.rgb.toHex())
                                }
                            Text("Top")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))
                            
                            Divider().padding(.vertical, 3)
                                .opacity(0.6)

                            ColourWheel(radius: 110, rgbColour: $mixer.bottomFaderB, brightness: $mixer.brBottomFaderB)
                            CustomSlider(rgbColour: $mixer.bottomFaderB, value: $mixer.brBottomFaderB, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.bottomFaderB.onChangeCompatible(br:mixer.brBottomFaderB)) { newValue in
                                   
                                    mixer.selectedDevice.SetFaderColours(faderName: selectedFader, colourTop: mixer.topFaderB.rgb.toHex(), colourBottom: mixer.bottomFaderB.rgb.toHex())

                                }
                            Text("Bottom")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))

                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                    
                    
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Mute button")
                                .font(.system(.title2))
                                .padding(.right, 110)
                                .padding(.bottom, 1)
                                .frame(alignment: .topLeading)
                            
                            Group {
                                Text("Off option")
                                    .padding(.top, 3)
                                    .padding(.bottom, 1)
                                    .opacity(0.8)
                                    .font(.system(.headline))
                                Picker("", selection: $mixer.buttonMuteBStyle){
                                    Text("Dimmed colour 1").tag(ButtonColourOffStyle.Dimmed)
                                    Text("Colour 2").tag(ButtonColourOffStyle.Colour2)
                                    Text("Dimmed colour 2").tag(ButtonColourOffStyle.DimmedColour2)
                                }.padding(.horizontal, 30)
                                    .onChange(of: mixer.buttonMuteBStyle) { newValue in
                                        mixer.selectedDevice.SetButtonOffStyle(button: .Fader2Mute, style: newValue)
                                    }
                                    .padding(.bottom, 3)
                                
                                Divider().padding(.vertical, 3)
                                    .opacity(0.6)
                            }
                            
                            ColourWheel(radius: 110, rgbColour: $mixer.buttonMuteBColour1, brightness: $mixer.brButtonMuteBColour1)
                            CustomSlider(rgbColour: $mixer.buttonMuteBColour1, value: $mixer.brButtonMuteBColour1, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.buttonMuteBColour1.onChangeCompatible(br:mixer.brButtonMuteBColour1)) { newValue in
                                    mixer.selectedDevice.SetButtonColours(button: .Fader2Mute, colour1: mixer.buttonMuteBColour1.rgb.toHex(), colour2: mixer.buttonMuteBColour2.rgb.toHex())
                                }
                            Text("Colour 1")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))
                            
                            Divider().padding(.vertical, 3)
                                .opacity(0.6)

                            ColourWheel(radius: 110, rgbColour: $mixer.buttonMuteBColour2, brightness: $mixer.brButtonMuteBColour2)
                            CustomSlider(rgbColour: $mixer.buttonMuteBColour2, value: $mixer.brButtonMuteBColour2, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.buttonMuteBColour2.onChangeCompatible(br:mixer.brButtonMuteBColour2)) { newValue in
                                    mixer.selectedDevice.SetButtonColours(button: .Fader2Mute, colour1: mixer.buttonMuteBColour1.rgb.toHex(), colour2: mixer.buttonMuteBColour2.rgb.toHex())
                                }
                            Text("Colour 2")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))

                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                }
                else if selectedFader == .C {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        VStack {
                            Text("Screen")
                                .font(.system(.title2))
                                .padding(.right, 160)
                                .padding(.bottom, 430)
                                .frame(alignment: .topLeading)
                        }
                        
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Fader")
                                .font(.system(.title2))
                                .padding(.right, 160)
                                .padding(.bottom, 1)
                                .frame(alignment: .topLeading)
                            
                            Group {
                                Text("Style")
                                    .padding(.top, 3)
                                    .padding(.bottom, 1)
                                    .opacity(0.8)
                                    .font(.system(.headline))
                                Picker("", selection: $mixer.styleFaderC){
                                    Text("Two colour").tag(FaderDisplayStyle.TwoColour)
                                    Text("Gradient").tag(FaderDisplayStyle.Gradient)
                                    
                                    Text("Meter").tag(FaderDisplayStyle.Meter)
                                    Text("Gradient meter").tag(FaderDisplayStyle.GradientMeter)
                                }.padding(.horizontal, 30)
                                    .onChange(of: mixer.styleFaderB) { newValue in
                                        mixer.selectedDevice.SetFaderDisplayStyle(faderName: .C, displayStyle: newValue)
                                    }
                                    .padding(.bottom, 3)
                                
                                Divider().padding(.vertical, 3)
                                    .opacity(0.6)
                            }
                            
                            ColourWheel(radius: 110, rgbColour: $mixer.topFaderC, brightness: $mixer.brTopFaderC)
                            CustomSlider(rgbColour: $mixer.topFaderC, value: $mixer.brTopFaderC, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.topFaderC.onChangeCompatible(br:mixer.brTopFaderC)) { newValue in

                                    mixer.selectedDevice.SetFaderColours(faderName: selectedFader, colourTop: mixer.topFaderC.rgb.toHex(), colourBottom: mixer.bottomFaderC.rgb.toHex())
                                }
                            Text("Top")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))
                            
                            Divider().padding(.vertical, 3)
                                .opacity(0.6)

                            ColourWheel(radius: 110, rgbColour: $mixer.bottomFaderC, brightness: $mixer.brBottomFaderC)
                            CustomSlider(rgbColour: $mixer.bottomFaderC, value: $mixer.brBottomFaderC, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.bottomFaderC.onChangeCompatible(br:mixer.brBottomFaderC)) { newValue in
                                   
                                    mixer.selectedDevice.SetFaderColours(faderName: selectedFader, colourTop: mixer.topFaderC.rgb.toHex(), colourBottom: mixer.bottomFaderC.rgb.toHex())

                                }
                            Text("Bottom")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))

                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                    
                    
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Mute button")
                                .font(.system(.title2))
                                .padding(.right, 110)
                                .padding(.bottom, 1)
                                .frame(alignment: .topLeading)
                            
                            Group {
                                Text("Off option")
                                    .padding(.top, 3)
                                    .padding(.bottom, 1)
                                    .opacity(0.8)
                                    .font(.system(.headline))
                                Picker("", selection: $mixer.buttonMuteCStyle){
                                    Text("Dimmed colour 1").tag(ButtonColourOffStyle.Dimmed)
                                    Text("Colour 2").tag(ButtonColourOffStyle.Colour2)
                                    Text("Dimmed colour 2").tag(ButtonColourOffStyle.DimmedColour2)
                                }.padding(.horizontal, 30)
                                    .onChange(of: mixer.buttonMuteCStyle) { newValue in
                                        mixer.selectedDevice.SetButtonOffStyle(button: .Fader3Mute, style: newValue)
                                    }
                                    .padding(.bottom, 3)
                                
                                Divider().padding(.vertical, 3)
                                    .opacity(0.6)
                            }
                            
                            ColourWheel(radius: 110, rgbColour: $mixer.buttonMuteCColour1, brightness: $mixer.brButtonMuteCColour1)
                            CustomSlider(rgbColour: $mixer.buttonMuteCColour1, value: $mixer.brButtonMuteCColour1, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.buttonMuteCColour1.onChangeCompatible(br:mixer.brButtonMuteCColour1)) { newValue in
                                    mixer.selectedDevice.SetButtonColours(button: .Fader3Mute, colour1: mixer.buttonMuteCColour1.rgb.toHex(), colour2: mixer.buttonMuteCColour2.rgb.toHex())
                                }
                            Text("Colour 1")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))
                            
                            Divider().padding(.vertical, 3)
                                .opacity(0.6)

                            ColourWheel(radius: 110, rgbColour: $mixer.buttonMuteCColour2, brightness: $mixer.brButtonMuteCColour2)
                            CustomSlider(rgbColour: $mixer.buttonMuteCColour2, value: $mixer.brButtonMuteCColour2, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.buttonMuteCColour2.onChangeCompatible(br:mixer.brButtonMuteCColour2)) { newValue in
                                    mixer.selectedDevice.SetButtonColours(button: .Fader3Mute, colour1: mixer.buttonMuteCColour1.rgb.toHex(), colour2: mixer.buttonMuteCColour2.rgb.toHex())
                                }
                            Text("Colour 2")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))

                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                }
                else if selectedFader == .D {
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        VStack {
                            Text("Screen")
                                .font(.system(.title2))
                                .padding(.right, 160)
                                .padding(.bottom, 430)
                                .frame(alignment: .topLeading)
                        }
                        
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Fader")
                                .font(.system(.title2))
                                .padding(.right, 160)
                                .padding(.bottom, 1)
                                .frame(alignment: .topLeading)
                            
                            Group {
                                Text("Style")
                                    .padding(.top, 3)
                                    .padding(.bottom, 1)
                                    .opacity(0.8)
                                    .font(.system(.headline))
                                Picker("", selection: $mixer.styleFaderD){
                                    Text("Two colour").tag(FaderDisplayStyle.TwoColour)
                                    Text("Gradient").tag(FaderDisplayStyle.Gradient)
                                    
                                    Text("Meter").tag(FaderDisplayStyle.Meter)
                                    Text("Gradient meter").tag(FaderDisplayStyle.GradientMeter)
                                }.padding(.horizontal, 30)
                                    .onChange(of: mixer.styleFaderD) { newValue in
                                        mixer.selectedDevice.SetFaderDisplayStyle(faderName: .D, displayStyle: newValue)
                                    }
                                    .padding(.bottom, 3)
                                
                                Divider().padding(.vertical, 3)
                                    .opacity(0.6)
                            }
                            
                            ColourWheel(radius: 110, rgbColour: $mixer.topFaderD, brightness: $mixer.brTopFaderD)
                            CustomSlider(rgbColour: $mixer.topFaderD, value: $mixer.brTopFaderD, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.topFaderD.onChangeCompatible(br:mixer.brTopFaderD)) { newValue in

                                    mixer.selectedDevice.SetFaderColours(faderName: selectedFader, colourTop: mixer.topFaderD.rgb.toHex(), colourBottom: mixer.bottomFaderD.rgb.toHex())
                                }
                            Text("Top")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))
                            
                            Divider().padding(.vertical, 3)
                                .opacity(0.6)

                            ColourWheel(radius: 110, rgbColour: $mixer.bottomFaderD, brightness: $mixer.brBottomFaderD)
                            CustomSlider(rgbColour: $mixer.bottomFaderD, value: $mixer.brBottomFaderD, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.bottomFaderD.onChangeCompatible(br:mixer.brBottomFaderD)) { newValue in
                                   
                                    mixer.selectedDevice.SetFaderColours(faderName: selectedFader, colourTop: mixer.topFaderD.rgb.toHex(), colourBottom: mixer.bottomFaderD.rgb.toHex())

                                }
                            Text("Bottom")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))

                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                    
                    
                    ZStack() {
                        RoundedRectangle(cornerRadius: 10).fill(.background)
                            .shadow(color:Color(hex: 000000, opacity: 0.1),radius: 15)
                        
                        VStack {
                            Text("Mute button")
                                .font(.system(.title2))
                                .padding(.right, 110)
                                .padding(.bottom, 1)
                                .frame(alignment: .topLeading)
                            
                            Group {
                                Text("Off option")
                                    .padding(.top, 3)
                                    .padding(.bottom, 1)
                                    .opacity(0.8)
                                    .font(.system(.headline))
                                Picker("", selection: $mixer.buttonMuteDStyle){
                                    Text("Dimmed colour 1").tag(ButtonColourOffStyle.Dimmed)
                                    Text("Colour 2").tag(ButtonColourOffStyle.Colour2)
                                    Text("Dimmed colour 2").tag(ButtonColourOffStyle.DimmedColour2)
                                }.padding(.horizontal, 30)
                                    .onChange(of: mixer.buttonMuteCStyle) { newValue in
                                        mixer.selectedDevice.SetButtonOffStyle(button: .Fader4Mute, style: newValue)
                                    }
                                    .padding(.bottom, 3)
                                
                                Divider().padding(.vertical, 3)
                                    .opacity(0.6)
                            }
                            
                            ColourWheel(radius: 110, rgbColour: $mixer.buttonMuteDColour1, brightness: $mixer.brButtonMuteDColour1)
                            CustomSlider(rgbColour: $mixer.buttonMuteDColour1, value: $mixer.brButtonMuteDColour1, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.buttonMuteDColour1.onChangeCompatible(br:mixer.brButtonMuteDColour1)) { newValue in
                                    mixer.selectedDevice.SetButtonColours(button: .Fader4Mute, colour1: mixer.buttonMuteDColour1.rgb.toHex(), colour2: mixer.buttonMuteDColour2.rgb.toHex())
                                }
                            Text("Colour 1")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))
                            
                            Divider().padding(.vertical, 3)
                                .opacity(0.6)

                            ColourWheel(radius: 110, rgbColour: $mixer.buttonMuteDColour2, brightness: $mixer.brButtonMuteDColour2)
                            CustomSlider(rgbColour: $mixer.buttonMuteDColour2, value: $mixer.brButtonMuteDColour2, range: 0.001...1).padding(.vertical, 4)
                                .padding(.horizontal)
                                .onChange(of: mixer.buttonMuteDColour2.onChangeCompatible(br:mixer.brButtonMuteDColour2)) { newValue in
                                    mixer.selectedDevice.SetButtonColours(button: .Fader4Mute, colour1: mixer.buttonMuteDColour1.rgb.toHex(), colour2: mixer.buttonMuteDColour2.rgb.toHex())
                                }
                            Text("Colour 2")
                                .padding(3)
                                .opacity(0.8)
                                .font(.system(.headline))

                        }
                    }.frame(width: 230, height: 460)
                        .padding(.horizontal, 2)
                }
            }
        }.navigationTitle(tabname!)
            .padding(.top, 1)
            .onAppear() {
                mixer.updateSlidersLightning()
            }
            .onChange(of: selectedFader) {newValue in
                mixer.updateSlidersLightning()
            }
            .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab: "device").environmentObject(mixer)})
            .toolbar {
                ToolbarItemGroup(placement:.automatic) {
                    Button(action: {mixer.profileSheet.toggle()}, label: {
                        Text("Load Profile")
                    })
                    Spacer()
                    Button(action: {MixerStatus().selectedDevice.SaveProfile()}, label: {
                        Text("Save Profile")
                    })
                }
                ToolbarItem(placement:.automatic) {
                    Text("　　　  ")
                }
                
                ToolbarItemGroup(placement:.automatic) {
                    Picker("Fader", selection: $selectedFader){
                        Text(" All ").tag(FadersLightning.All)
                        Text(" A ").tag(FadersLightning.A)
                        Text(" B ").tag(FadersLightning.B)
                        Text(" C ").tag(FadersLightning.C)
                        Text(" D ").tag(FadersLightning.D)
                    }.pickerStyle(.segmented)
                }
            }

    }
}
