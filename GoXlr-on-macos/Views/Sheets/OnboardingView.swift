//
//  OnboardingView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 27/07/2022.
//

import Foundation
import SwiftUI
import SimplyCoreAudio
import ServiceManagement

let simplyCA = SimplyCoreAudio()

struct OnboardingView: View {
    @State var step = 1
    @State var audioReminder = false
    @Binding var onboarded: Bool
    @State var launchAtStartup = true
    var body: some View {
        VStack(alignment: .center) {
            if step == 1 {
                VStack(alignment: .center) {
                    Image("appicon-img").resizable()
                        .frame(width: 70, height: 70)
                        .padding()
                    
                    Text("Welcome to GoXLR MacOS")
                        .bold()
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                    VStack(alignment: .leading) {
                        InformationDetailView(title: "Configure your device", subTitle: "Easely setup your mixer with a native and easy-to-use UI.", imageName: "slider.vertical.3")
                        InformationDetailView(title: "Don't worry aboout technical stuff", subTitle: "Make sure that your device is always ready to use.", imageName: "bolt.horizontal.circle")
                        InformationDetailView(title: "Find the perfect mix", subTitle: "Fully enjoy your device with all the audio devices created and managed for you.", imageName: "waveform")
                    }.frame(width: 480).padding(.bottom, 20)
                    Button(action: {
                        step = 2
                        
                    }) {
                        Text("Start")
                            .padding(22)
                            .frame(width: 200, height: 30)
                            .background(Color.accentColor)
                            .foregroundColor(Color.white)
                    }.frame(width: 200, height: 30)
                     .background(Color.accentColor).cornerRadius(10)
                     .padding(.bottom, 10)

                }.frame(width: 600, height:460)
                    .background(.background)
            }
            else if step == 2 {
                
                VStack(alignment: .center) {
                    Image(systemName:"waveform")
                        .font(.system(size: 50))
                        .foregroundColor(.accentColor)
                        .padding(.top, 10)
                    Text("Audio Setup")
                        .font(.largeTitle)
                        .padding(.bottom, 5)
                        .padding(.top, 5)

                    
                    Text("First, we need to create all the appropriate audio devices.")
                        .font(.system(.headline))
                        .padding(.bottom, 5)


                    Divider().padding(.bottom, 10).opacity(0.3)
                    
                    HStack {
                        Text("•  Before clicking \"Continue\", make sure you selected the GoXLR as default audio device.")
                            .font(.system(
                                .title3,
                                design: .rounded
                            ))
                            .padding(.left, 50)
                            .padding(.right, 10)
                        Image("sound-setup-screen").resizable()
                            .frame(width: 271, height: 195)
                            .cornerRadius(5)
                            .padding()
                    }
                    

                }.frame(width: 600, height: 400)
                    .background(.background)
                    .toolbar {
                        ToolbarItem(placement: .confirmationAction) {
                            Button(action: {
                                audioReminder = true
                            }) {
                                Text("Continue")
                                    .frame(width: 150, height: 25)
                                    .background(Color.accentColor)
                                    .foregroundColor(Color.white)
                            }.frame(width: 150, height: 25)
                             .background(Color.accentColor).cornerRadius(10)
                             
                        }
                        ToolbarItem(placement: ToolbarItemPlacement.cancellationAction) {
                            Button(action: {step = 3}, label: {
                                Text("Skip")
                                    .foregroundColor(.gray)
                                    .background(Color.clear)
                            }).background(Color.clear)
                        }
                        ToolbarItem(placement: ToolbarItemPlacement.destructiveAction) {
                            Button(action: {step = 1}, label: {
                                Label("Back", systemImage: "chevron.left")
                                    .foregroundColor(.gray)
                                    .background(Color.clear)
                            }).background(Color.clear)
                        }
                    }
                    .alert("What is the model of your GoXlr ?", isPresented: $audioReminder) {
                        Button("Cancel", role: .cancel) {
                            audioReminder = false
                        }
                        Button("Mini", role: .destructive) {
                            audioReminder = AudioSetup(model: .Mini)
                        }
                        Button("Full", role: .destructive) {
                            audioReminder = AudioSetup(model: .Full)
                        }
                    }
                    
            }
            else if step == 3 {
                VStack(alignment: .center) {
                   
                    Text("Setup done !")
                        .bold()
                        .font(.largeTitle)
                        .padding(.bottom, 20)
                        .padding(.top, 20)

                    Text("Enjoy your device !")
                        .font(.system(.headline))
                        .padding(.bottom, 10)
                    HStack {
                        Text("Launch at login")
                        Toggle(isOn: $launchAtStartup) {}
                            .toggleStyle(.switch)
                            .scaleEffect(0.7)
                    }.padding(.bottom, 5)
                    Image(systemName:"checkmark.circle")
                        .font(.system(size: 70))
                        .foregroundColor(.accentColor)
                        .padding(60)
                    
                    Button(action: {
                        if launchAtStartup {
                            let service = SMAppService.mainApp
                            do { try service.register()
                            } catch { print("Unable to register \(error)") }
                        }
                        
                        let agent = SMAppService.agent(plistName: "com.adesky.goxlr.plist")
                        do { try agent.register()
                        } catch { print("Unable to register \(error)") }
                        
                        step = 4
                        UserDefaults.standard.set(true, forKey: "firstLaunch")
                        onboarded = false
                    }) {
                        Text("Finish")
                            .padding(22)
                            .frame(width: 200, height: 30)
                            .background(Color.accentColor)
                            .foregroundColor(Color.white)
                    }.frame(width: 200, height: 30)
                     .background(Color.accentColor).cornerRadius(10)
                     .padding(.bottom, 10)

                }.frame(width: 600, height:460)
                    .background(.background)
            }
        }.frame(width: 600, height: step > 1 ? 400 : 460)
            .background(.background)
    }
}

struct InformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .font(.largeTitle)
                .foregroundColor(.accentColor)
                .padding()

            VStack(alignment: .leading) {
                Text(title)
                    .font(.headline)
                    .foregroundColor(.primary)

                Text(subTitle)
                    .font(.body)
                    .foregroundColor(.secondary)
                    .fixedSize(horizontal: false, vertical: true)
            }
        }
    }
}
