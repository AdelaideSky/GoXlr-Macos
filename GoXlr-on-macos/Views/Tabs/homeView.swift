//
//  homeView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 07/07/2022.
//
import SwiftUI
import UniformTypeIdentifiers

struct HomeView: View {
    @State var tabname: String? = "Home"
    
    @State var onboarded = !UserDefaults.standard.bool(forKey: "firstLaunch")
    @EnvironmentObject var mixer: MixerStatus
    
    var body: some View {
        VStack(alignment: .center) {
            
            Text("👋")
                .font(.system(size: 60))
            Text("Welcome " + NSFullUserName() + " !")
                .bold()
                .font(.system(size: 45))
                .fontWeight(.heavy)
            Text("Connect your GoXlr to get started")
                .padding(.top)
                .font(.title3)
            
        }.sheet(isPresented: $onboarded) {
            OnboardingView(onboarded: $onboarded)
        }
            .navigationTitle(tabname!)
            .sheet(isPresented: $mixer.profileSheet, content: {LoadProfileView(defaultTab: "device").environmentObject(mixer)})
            
            .toolbar {
                ToolbarItem(placement: .automatic) {
                    Button(action: {mixer.profileSheet.toggle()}, label: {
                        Text("Load Profile")
                    })
                }
                ToolbarItem(placement: .automatic) {
                    Button(action: {MixerStatus().selectedDevice.SaveProfile()}, label: {
                        Text("Save Profile")
                    })
                }
            }
                
    }
}
