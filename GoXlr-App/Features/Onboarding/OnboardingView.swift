//
//  OnboardingView.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 08/05/2023.
//

import SwiftUI
import GoXlrKit
import GoXlrKit_Audio

struct OnboardingView: View {
    @State var step: Int = 1
    var body: some View {
        VStack {
//            Button("not first launch") {
//                AppSettings.shared.firstLaunch.toggle()
//            }
            
            if step == 1 {
                FirstOnboardingPage($step)
            } else if step == 2 {
                SecondOnboardingPage($step)
            } else if step == 3 {
                ThirdOnboardingPage($step)
            }
            
        }.frame(width: 500, height: 550)
            .padding(.horizontal)
            .padding(.bottom)
            .animation(.default, value: step)
    }
}

struct FirstOnboardingPage: View {
    @Binding var page: Int
    
    public init(_ page: Binding<Int>) {
        self._page = page
    }
    
    @State var isInstalling: Bool = false
    
    var body: some View {
        VStack {
            Image("AppIcon.image")
                .resizable()
                .scaledToFit()
                .frame(width: 100)
                .shadow(color: Color(hex: "096A7F"), radius: 20)
                .padding(.bottom, 5)
            Text("Welcome to GoXLR-App !")
                .font(.largeTitle)
                .bold()
            Spacer()
            VStack(alignment: .leading, spacing: 20) {
                InformationDetailView(title: "Re-built from the ground", subTitle: "Everything works as intended, live-updated and optimised, here's the brand new GoXlr-MacOS App !", imageName: "sparkles")
//                InformationDetailView(title: "Easy-to-use", subTitle: "You don’t need to bother about dealing with complex commands. Everything is here, just a matter of buttons and sliders.", imageName: "person.crop.circle.badge.checkmark")
                InformationDetailView(title: "Menubar-based", subTitle: "Your GoXLR settings are always one click away. No dock icon, just a little icon on your menubar, to adjust settings on the go.", imageName: "filemenu.and.cursorarrow")
                InformationDetailView(title: "Profile Seamless Handling", subTitle: "Just import your profiles from your Windows PC, and double click them in Finder, they will automatically load.", imageName: "doc.on.doc")
            }.padding(.horizontal, 15)
            Spacer()
            Button(action: {
                isInstalling = true
                DispatchQueue(label: "driversInstaller").async {
                    AppSettings.shared.initialiseApp()
                    DispatchQueue.main.sync {
                        self.page += 1
                    }
                }
                
            }, label: {
                HStack {
                    Text("Install required drivers")
                        .font(.headline)
                    if isInstalling {
                        ProgressView()
                            .scaleEffect(0.5)
                            .frame(height: 15)
                    }
                }.animation(.default, value: isInstalling)
            })
            .disabled(isInstalling)
            .buttonStyle(.prominent)
        }
    }
}

struct InformationDetailView: View {
    var title: String = "title"
    var subTitle: String = "subTitle"
    var imageName: String = "car"

    var body: some View {
        HStack(alignment: .center) {
            Image(systemName: imageName)
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(width: 30)
                .padding(.horizontal)

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

struct SecondOnboardingPage: View {
    @Binding var page: Int
    
    public init(_ page: Binding<Int>) {
        self._page = page
    }
    
    @ObservedObject var status = GoXlr.shared.status!.data.status
    
    @State var setupingAudio: Bool = false
    @State var showsHelp: Bool = false
    @State var showsSkipAlert: Bool = false
        
    var body: some View {
        VStack {
            Image(systemName: "waveform")
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(width: 50)
                .padding(.bottom, 5)
            Text("Audio Set-Up")
                .font(.largeTitle)
                .bold()
            Spacer()
            Form {
                if status.mixers.count < 1 {
                    Section() {
                        HStack {
                            Spacer()
                            VStack {
                                ProgressView()
                                    .scaleEffect(0.6)
                                    .padding(.bottom, 5)
                                Text("Looking for devices...")
                                    .font(.headline)
                                    .bold()
                                Text("Please try restarting your device, or reconnecting it.")
                                    .font(.subheadline)
                                if showsHelp {
                                    Text("Still don't see your device ?")
                                        .font(.subheadline)
                                        .padding(.top, 15)
                                        .padding(.bottom, -3)
                                    Text("You can join the [support discord server](https://discord.gg/cyavp8F2WW) to reach for help !")
                                        .font(.subheadline)
                                }
                            }.opacity(0.5)
                                .padding()
                            Spacer()
                        }
                    }
                    .onAppear(perform: {
                        withAnimation(Animation.default.delay(30)) {
                            self.showsHelp.toggle()
                        }
                     })
                } else if let mixer = GoXlr.shared.mixer {
                    Section("Found a device") {
                        HStack {
                            Text("Model type")
                            Spacer()
                            Text(mixer.hardware.deviceType.rawValue)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Manufactured date")
                            Spacer()
                            Text(mixer.hardware.manufacturedDate)
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Firmware version")
                            Spacer()
                            Text("\(mixer.hardware.versions.firmware.compactMap({ "\($0)" }).joined(separator: "."))")
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("FPGA")
                            Spacer()
                            Text("\(mixer.hardware.versions.fpgaCount)")
                                .textSelection(.enabled)
                        }
                        HStack {
                            Text("Serial number")
                            Spacer()
                            Text(mixer.hardware.serialNumber)
                                .textSelection(.enabled)
                        }
                    }
                }
            }.formStyle(.grouped)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .animation(.default, value: GoXlr.shared.device)
            Spacer()
            HStack(spacing: 10) {
                
                Button(action: {
                    showsSkipAlert = true
                }, label: {
                    Text("Skip")
                }).buttonStyle(.secondaryProminent)
                    .opacity(0.5)
                
                    .alert("Are you sure you want to skip Audio Setup ?", isPresented: $showsSkipAlert, actions: {
                        Button("Skip", role: .destructive) {
                            page += 1
                        }
                        Button("Cancel", role: .cancel) {}
                    }, message: {
                        Text("You can still do it later in the settings.")
                    })
                
                Button(action: {
                    if let device = GoXlr.shared.mixer {
                        setupingAudio = true
                        DispatchQueue(label: "audioSetup").async {
                            switch device.hardware.deviceType {
                            case .Full:
                                GoXlrAudio.shared.setUp.createAggregates(.Full, serial: device.hardware.serialNumber)
                            case .Mini:
                                GoXlrAudio.shared.setUp.createAggregates(.Mini, serial: device.hardware.serialNumber)
                            }
                            DispatchQueue.main.sync {
                                setupingAudio = false
                                page += 1
                            }
                        }
                    }
                    
                }, label: {
                    HStack {
                        Text("Create audio devices")
                            .font(.headline)
                        if setupingAudio {
                            ProgressView()
                                .scaleEffect(0.5)
                                .frame(height: 15)
                        }
                    }.animation(.default, value: setupingAudio)
                }).buttonStyle(.prominent)
            }
            .disabled(status.mixers.count < 1 || setupingAudio)
            
        }
    }
}

struct ThirdOnboardingPage: View {
    
    @Binding var page: Int
    
    public init(_ page: Binding<Int>) {
        self._page = page
    }
    
    @ObservedObject var status = GoXlr.shared.status!.data.status
    @ObservedObject var settings = AppSettings.shared
    
        
    var body: some View {
        VStack {
            Image(systemName: "checkmark.seal")
                .resizable()
                .scaledToFit()
                .foregroundColor(.accentColor)
                .frame(width: 50)
                .padding(.bottom, 5)
            Text("You're all set !")
                .font(.largeTitle)
                .bold()
            Text("Check your menubar for the GoXLR icon to configure your device !")
                .padding(.bottom)
            Form {
                Section() {
                    Toggle("Launch app at startup", isOn: $settings.launchAtStartup)
                    Toggle("Launch app on device connect", isOn: $settings.launchOnConnect)
                }
            }.formStyle(.grouped)
                .scrollContentBackground(.hidden)
                .scrollDisabled(true)
                .fixedSize(horizontal: false, vertical: true)
                .padding(.horizontal)
                .onAppear() {
                    settings.launchAtStartup = true
                }
            
            Spacer()
            HStack(spacing: 10) {
                
                Button(action: {
                    settings.firstLaunch.toggle()
                    
                    for window in NSApplication.shared.windows {
                        if window.identifier?.rawValue == "onboarding" {
                            window.close()
                        }
                    }
                    
                }, label: {
                    HStack {
                        Text("Start using the app !")
                            .font(.headline)
                    }
                }).buttonStyle(.prominent)
            }
            
        }
    }
}
