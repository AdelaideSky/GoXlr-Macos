//
//  ContentView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 02/07/2022.
//

import SwiftUI


struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    @ObservedObject var mixer: MixerStatus
    func toggleSidebar() {
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    var body: some View {
        if mixer.selectedDevice.deviceType() == .Full {
            NavigationView {
                List {

                    Group {
                        NavigationLink(destination: HomeView().environmentObject(mixer)) {
                            Label("Home", systemImage: "house")
                        }
                        
                        Spacer()
                        
                        Text("AUDIO")
                            .font(.system(size: 10))
                            .fontWeight(.bold)
                    }
                    Group{
                        NavigationLink(destination: MicView().environmentObject(mixer)) {
                            Label("Mic", systemImage: "mic")
                        }
                        NavigationLink(destination: MixerView().environmentObject(mixer)) {
                            Label("Mixer", systemImage: "slider.vertical.3")
                        }
                        NavigationLink(destination: FxView().environmentObject(mixer)) {
                            Label("Effects", systemImage: "fx")
                        }
                        NavigationLink(destination: NotCreatedView().environmentObject(mixer)) {
                            Label("Sampler", systemImage: "waveform")
                        }
                        NavigationLink(destination: RoutingView().environmentObject(mixer)) {
                            Label("Routing", systemImage: "app.connected.to.app.below.fill")
                        }
                    }
                    
                    Spacer()
                    
                    Text("LIGHTNING")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    Group {
                        NavigationLink(destination: NotCreatedView().environmentObject(mixer)) {
                            Label("Global", systemImage: "sun.min")
                        }
                        NavigationLink(destination: MixerLightningView().environmentObject(mixer)) {
                            Label("Mixer", systemImage: "slider.vertical.3")
                        }
                        NavigationLink(destination: NotCreatedView().environmentObject(mixer)) {
                            Label("Effects", systemImage: "fx")
                        }
                        NavigationLink(destination: NotCreatedView().environmentObject(mixer)) {
                            Label("Sampler", systemImage: "waveform")
                        }
                    }
                    
                    
                    Divider()
                    Group {
                        NavigationLink(destination: SettingsView().environmentObject(mixer)) {
                            Label("Settings", systemImage: "gear")
                        }
                        NavigationLink(destination: AboutView().environmentObject(mixer)) {
                            Label("About", systemImage: "info.circle")
                        }
                    }
                    
                }
                .listStyle(SidebarListStyle())
                .navigationTitle("Explore")
                .frame(minWidth: 150, idealWidth: 250, maxWidth: 300)
                .toolbar {
                    
                    ToolbarItem(placement: .navigation) {
                        Button(action: toggleSidebar, label: {
                            Image(systemName: "sidebar.left")
                        })
                    }
                    if GoXlr().listDevices().count > 1 {
                        ToolbarItem(placement: .navigation) {
                            Picker("", selection: $mixer.selectedDevice) {
                                ForEach(GoXlr().listDevices(), id: \.self) { value in
                                    Text(value[1]+" - "+value[0]).tag(GoXlr(serial: value[0]))}}
                        }
                    }
                }
                
                HomeView()
                    .environmentObject(MixerStatus())
            }
        }
        
        else {
            NavigationView {
                List {
                    
                    Group {
                        NavigationLink(destination: HomeView().environmentObject(mixer)) {
                            Label("Home", systemImage: "house")
                        }
                        
                        Spacer()
                        
                        Text("AUDIO")
                            .font(.system(size: 10))
                            .fontWeight(.bold)
                    }
                    Group{
                        NavigationLink(destination: miniMicView().environmentObject(mixer)) {
                            Label("Mic", systemImage: "mic")
                        }
                        NavigationLink(destination: MixerView().environmentObject(mixer)) {
                            Label("Mixer", systemImage: "slider.vertical.3")
                        }
                        NavigationLink(destination: RoutingView().environmentObject(mixer)) {
                            Label("Routing", systemImage: "app.connected.to.app.below.fill")
                        }
                    }
                    
                    Spacer()
                    
                    Text("LIGHTNING")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    Group {
                        NavigationLink(destination: NotCreatedView().environmentObject(mixer)) {
                            Label("Global", systemImage: "sun.min")
                        }
                        NavigationLink(destination: MixerLightningView().environmentObject(mixer)) {
                            Label("Mixer", systemImage: "slider.vertical.3")
                        }
                    }
                    
                    Group {
                        Spacer()
                        Spacer()
                        Spacer()
                        Spacer()
                    }
                    
                    Divider()
                    Group {
                        NavigationLink(destination: SettingsView().environmentObject(mixer)) {
                            Label("Settings", systemImage: "gear")
                        }
                        NavigationLink(destination: AboutView().environmentObject(mixer)) {
                            Label("About", systemImage: "info.circle")
                        }
                    }
                    
                }
                .listStyle(SidebarListStyle())
                .navigationTitle("Explore")
                .frame(minWidth: 150, idealWidth: 250, maxWidth: 300)
                
                .toolbar {
                    
                    ToolbarItem(placement: .navigation) {
                        Button(action: toggleSidebar, label: {
                            Image(systemName: "sidebar.left")
                        })
                    }
                    if GoXlr().listDevices().count > 1 {
                        ToolbarItem(placement: .navigation) {
                            Picker("", selection: $mixer.selectedDevice) {
                                ForEach(GoXlr().listDevices(), id: \.self) { value in
                                    Text(value[1]+" - "+value[0]).tag(GoXlr(serial: value[0]))}}
                        }
                    }
                }
                
                HomeView()
                    .environmentObject(mixer)
            }
        }
    }
}
