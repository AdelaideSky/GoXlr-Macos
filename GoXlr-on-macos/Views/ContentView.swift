//
//  ContentView.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 02/07/2022.
//

import SwiftUI

struct ContentView: View {
    @Environment(\.openWindow) private var openWindow
    
    func toggleSidebar() {
            NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
    }
    
    var body: some View {
        if MixerStatus().selectedDevice.deviceType() == .Full {
            NavigationView {
                List {
                    NavigationLink(destination: HomeView().environmentObject(MixerStatus())) {
                        Label("Home", systemImage: "house")
                    }
                    
                    Spacer()
                    
                    Text("AUDIO")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    Group{
                        NavigationLink(destination: MicView().environmentObject(MixerStatus())) {
                            Label("Mic", systemImage: "mic")
                        }
                        NavigationLink(destination: MixerView().environmentObject(MixerStatus())) {
                            Label("Mixer", systemImage: "slider.vertical.3")
                        }
                        NavigationLink(destination: NotCreatedView().environmentObject(MixerStatus())) {
                            Label("Effects", systemImage: "fx")
                        }
                        NavigationLink(destination: NotCreatedView().environmentObject(MixerStatus())) {
                            Label("Sampler", systemImage: "waveform")
                        }
                        NavigationLink(destination: RoutingView().environmentObject(MixerStatus())) {
                            Label("Routing", systemImage: "app.connected.to.app.below.fill")
                        }
                    }
                    
                    Spacer()
                    
                    Text("LIGHTNING")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    Group {
                        NavigationLink(destination: NotCreatedView().environmentObject(MixerStatus())) {
                            Label("Global", systemImage: "sun.min")
                        }
                        NavigationLink(destination: MixerLightningView().environmentObject(MixerStatus())) {
                            Label("Mixer", systemImage: "slider.vertical.3")
                        }
                        NavigationLink(destination: NotCreatedView().environmentObject(MixerStatus())) {
                            Label("Effects", systemImage: "fx")
                        }
                        NavigationLink(destination: NotCreatedView().environmentObject(MixerStatus())) {
                            Label("Sampler", systemImage: "waveform")
                        }
                    }
                    
                    
                    Divider()
                    Group {
                        NavigationLink(destination: SettingsView().environmentObject(MixerStatus())) {
                            Label("Settings", systemImage: "gear")
                        }
                        NavigationLink(destination: NotCreatedView().environmentObject(MixerStatus())) {
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
                }
                
                HomeView()
                    .environmentObject(MixerStatus())
            }
        }
        
        else {
            NavigationView {
                List {
                    NavigationLink(destination: HomeView().environmentObject(MixerStatus())) {
                        Label("Home", systemImage: "house")
                    }
                    
                    Spacer()
                    
                    Text("AUDIO")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    Group{
                        NavigationLink(destination: miniMicView().environmentObject(MixerStatus())) {
                            Label("Mic", systemImage: "mic")
                        }
                        NavigationLink(destination: MixerView().environmentObject(MixerStatus())) {
                            Label("Mixer", systemImage: "slider.vertical.3")
                        }
                        NavigationLink(destination: RoutingView().environmentObject(MixerStatus())) {
                            Label("Routing", systemImage: "app.connected.to.app.below.fill")
                        }
                    }
                    
                    Spacer()
                    
                    Text("LIGHTNING")
                        .font(.system(size: 10))
                        .fontWeight(.bold)
                    Group {
                        NavigationLink(destination: NotCreatedView().environmentObject(MixerStatus())) {
                            Label("Global", systemImage: "sun.min")
                        }
                        NavigationLink(destination: NotCreatedView().environmentObject(MixerStatus())) {
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
                        NavigationLink(destination: SettingsView().environmentObject(MixerStatus())) {
                            Label("Settings", systemImage: "gear")
                        }
                        NavigationLink(destination: NotCreatedView().environmentObject(MixerStatus())) {
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
                }
                
                HomeView()
                    .environmentObject(MixerStatus())
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
