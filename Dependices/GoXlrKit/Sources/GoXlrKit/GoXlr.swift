import Foundation
import Starscream
import SwiftyJSON
import RegexBuilder

/**
 GoXlr class. You can either initialise it or use the `shared` instance.
 This class conforms to ObservableObject.
 */
public class GoXlr: ObservableObject {
    
    public static var shared: GoXlr = {
        return GoXlr()
    }()
    
    @Published public var status: Status? = nil
    public var mixer: Mixer? {
        get {
            status?.data.status.mixers[device]
        }
        set {
            status?.data.status.mixers[device] = newValue
        }
    }
    public var holdUpdates: Bool = false
        
    public var daemon = Daemon()
    
    public var socket = DaemonWSocket()
    
    public var device = ""
    
    public var logLevel: GoXlrLogLevel = .info
    
    /**
     Starts the daemon and connects to its Websocket.
     *Note: Websocket port is always 14564. The usecase where the daemon websocket isn't at the default port isn't already implemented.*
     */
    public func startObserving() {
        Task {
            self.daemon.start(args: nil)
            sleep(2)
            self.socket.connect()
        }
    }
    /**
     Disconnects from the websocket and shut down the daemon.
     */
    public func stopObserving() {
        Task {
            self.socket.disconnect()
            self.daemon.stop()
        }
    }
    
    /**
     Sends a command to the daemon websocket to the `device` mixer.
     - Parameters:
        - command: The command to send, in `GoXLRCommand` type.
     */
    public func command(_ command: GoXLRCommand) {
        do {
            let command = String(data: try JSONEncoder().encode(command), encoding: .utf8)
            let firstRegex = #/\"_[0-9]\":/#
            let secondRegex = #/\":{/#
            let thirdRegex = #/}}/#
            if let commandString = command?.replacing(firstRegex, with: "").replacing(secondRegex, with: "\":[").replacing(thirdRegex, with: "]}") {
                self.socket.sendCommand(string: "{\"id\": 0, \"data\": {\"Command\": [\"\(self.device)\", "+commandString+"]}}")
            }
        } catch {}
    }
    
    public init() {}
    
    public enum GoXlrLogLevel {
        case none
        case info
        case debug
    }
}
