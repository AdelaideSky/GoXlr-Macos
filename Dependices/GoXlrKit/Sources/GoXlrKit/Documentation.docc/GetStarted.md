# Get started

Easily implement GoXlrKit in a SwiftUI app.

## Sample code

```swift
import SwiftUI
import GoXlrKit

struct ContentView: View {
    
    @ObservedObject var goxlr = GoXlr.shared
    
    var body: some View {
        VStack {
            if goxlr.status != nil {
                Text("Connected to the Daemon with GoXlr \(goxlr.device)")
                    .padding()
                Text("Goxlr's System volume: \(goxlr.mixer?.levels.volumes.system ?? 0)")
                Button("Set System volume to 100%") {
                    guard goxlr.device != "" else { return } // check if a GoXlr is connected
                    
                    goxlr.mixer!.levels.volumes.system = 255 //Set System volume to maximum. Volumes are a Float going from 0 to 255 (The daemon only uses Int values but GoXlrKit provides Float values to allow directly binding to sliders)
                    //As you can see, you don't need to manually send the commands to the Daemon: the module does it by itself.
                }.disabled(goxlr.status == nil)
                
            } else {
                ProgressView()
            }
        }.onAppear() {
            goxlr.startObserving() // Start the Daemon and connect to its WebSocket
            //If you don't need to connect to the websocket, you can do goxlr.daemon.start(args: [DaemonArguments])
            //If you only need to connect to the websocket, do goxlr.socket.connect()
            
            //Make sure the utility isn't already launched, else the app will crash
        }
        .padding()
    }
}
```
