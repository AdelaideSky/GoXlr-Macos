
import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            List {
                NavigationLink(destination: HomeView()) {
                    Label("Home", systemImage: "house")
                }
                
                Spacer()
                
                Text("AUDIO")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                Group{
                    NavigationLink(destination: MicView()) {
                        Label("Mic", systemImage: "mic")
                    }
                    NavigationLink(destination: ControlView()) {
                        Label("Mixer", systemImage: "slider.vertical.3")
                    }
                    NavigationLink(destination: NotCreatedView()) {
                        Label("Effects", systemImage: "fx")
                    }
                    NavigationLink(destination: NotCreatedView()) {
                        Label("Sampler", systemImage: "waveform")
                    }
                    NavigationLink(destination: RoutingView()) {
                        Label("Routing", systemImage: "app.connected.to.app.below.fill")
                    }
                }
                
                Spacer()
                
                Text("LIGHTNING")
                    .font(.system(size: 10))
                    .fontWeight(.bold)
                Group {
                    NavigationLink(destination: NotCreatedView()) {
                        Label("Global", systemImage: "sun.min")
                    }
                    NavigationLink(destination: NotCreatedView()) {
                        Label("Mixer", systemImage: "slider.vertical.3")
                    }
                    NavigationLink(destination: NotCreatedView()) {
                        Label("Effects", systemImage: "fx")
                    }
                    NavigationLink(destination: NotCreatedView()) {
                        Label("Sampler", systemImage: "waveform")
                    }
                }
                
                Spacer()
                
                Divider()
                Group {
                    NavigationLink(destination: SettingsView()) {
                        Label("Settings", systemImage: "gear")
                    }
                    NavigationLink(destination: AboutView()) {
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
        }
    }
}

// Toggle Sidebar Function
func toggleSidebar() {
        NSApp.keyWindow?.firstResponder?.tryToPerform(#selector(NSSplitViewController.toggleSidebar(_:)), with: nil)
}

struct SidebarView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
