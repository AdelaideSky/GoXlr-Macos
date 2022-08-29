import SwiftUI
import Socket
import AppKit
import Foundation
import SwiftyJSON
import SimplyCoreAudio


class Config: ObservableObject {
    public init() {
        if UserDefaults.standard.bool(forKey: "debugMode") {
            debugMode = true
            
            if UserDefaults.standard.bool(forKey: "showStatusRequest") {
                showStatusRequests = true
            }
            else {
                showStatusRequests = false
            }
        }
        else {
            
            debugMode = false
            showStatusRequests = false
        }
        onScreenFader1 = UserDefaults.standard.string(forKey: "onScreenFader1") ?? "none"
        onScreenFader1Vol = UserDefaults.standard.float(forKey: "onScreenFader1Vol")

        onScreenFader2 = UserDefaults.standard.string(forKey: "onScreenFader2") ?? "none"
        onScreenFader2Vol = UserDefaults.standard.float(forKey: "onScreenFader2Vol")


        

    }
    let debugMode: Bool
    let showStatusRequests: Bool
    @Published var onScreenFader1: String
    @Published var onScreenFader1Vol: Float

    @Published var onScreenFader2: String
    @Published var onScreenFader2Vol: Float


}

//--------------------------------[Extensions]-------------------------------------------------//

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
    }
}
extension Collection {

    subscript(optional i: Index) -> Iterator.Element? {
        return self.indices.contains(i) ? self[i] : nil
    }

}

//--------------------------------[Funcs utils]-------------------------------------------------//

func hexStringToData(string: String) -> Data {
    let stringArray = Array(string)
    var data: Data = Data()
    
    for i in stride(from: 0, to: string.count, by: 2) {
        
        let pair: String = String(stringArray[i]) + String(stringArray[i+1])
        
        if let byteNum = UInt8(pair, radix: 16) {
            
            let byte = Data([byteNum])
            
            data.append(byte)
        }
        
        else{
            fatalError()
        }
    }
    return data
}

//Creating header of 4 bytes containing the length of the request.
func createrequest(request: String) -> Data {
    let len = String(format: "%02X", request.utf8.count)
    let hexlen = hexStringToData(string: len).bytes
    let header = [hexlen.indices.contains(3) ? hexlen[3] : 0x00, hexlen.indices.contains(2) ? hexlen[2] : 0x00, hexlen.indices.contains(1) ? hexlen[1] : 0x00, hexlen[0]]
    let body = request.data(using: .utf8)!
    let request = Data(header+body)
    return request
}

//--------------------------------[Structs]-------------------------------------------------//


public struct DaemonSocket {
    //Representing a socket of GoXlr-Daemon
    
    
    public init() {}
    
    //return a Socket object with the default path of the dameon socket.
    public func new() -> Socket {
    
        var daemonSocket: Socket? = nil
        do {
            try daemonSocket = Socket.create(family: .unix)
            try daemonSocket?.connect(to: "/tmp/goxlr.socket")
            return daemonSocket!
            
        } catch {
            print("Error when connecting to the socket")
            return daemonSocket!
        }
    }
    
    //Return a string of available data from the socket.
    public func read(socket: Socket) -> JSON {
        if Config().debugMode {
            if Config().showStatusRequests {
                do {
                    var data = Data()
                    try socket.read(into: &data)
                    
                    let string = String(decoding: data.dropFirst(4), as: UTF8.self)
                    print("---------------------------------[ READ ]-----------------------------------------\n")
                    print(string)
                    print("\n")
                    return JSON.init(parseJSON: string)
                } catch {
                    print("Error when reading the socket")
                    return "Error when reading the socket"
                }
            }
            else {
                do {
                    var data = Data()
                    try socket.read(into: &data)
                    
                    let string = String(decoding: data.dropFirst(4), as: UTF8.self)
                    
                    if string.starts(with: "{\"Status\":") {
                        return JSON.init(parseJSON: string)
                    }
                    
                    else {
                        print("---------------------------------[ READ ]-----------------------------------------\n")
                        print(string)
                        print("\n")
                        

                        
                        return JSON.init(parseJSON: string)
                    }
                } catch {
                    print("Error when reading the socket")
                    return "Error when reading the socket"
                }
            }
        }
        else {
            do {
                var data = Data()
                try socket.read(into: &data)
                
                let string = String(decoding: data.dropFirst(4), as: UTF8.self)
                return JSON.init(parseJSON: string)
            } catch {
                print("Error when reading the socket")
                return "Error when reading the socket"
            }
        }
    }
    public func dataRead(socket: Socket) -> Data {
        if Config().debugMode {
            if Config().showStatusRequests {
                do {
                    var data = Data()
                    try socket.read(into: &data)
                    data = data.dropFirst(4)
                    let string = String(decoding: data.dropFirst(4), as: UTF8.self)
                    print("---------------------------------[ READ ]-----------------------------------------\n")
                    print(string)
                    print("\n")
                    return data
                } catch {
                    print("Error when reading the socket")
                    return Data()
                }
            }
            else {
                do {
                    var data = Data()
                    try socket.read(into: &data)
                    data = data.dropFirst(4)
                    let string = String(decoding: data.dropFirst(4), as: UTF8.self)
                    
                    if string.starts(with: "{\"Status\":") {
                        return data
                    }
                    else if string.starts(with: "atus\":") {
                        return data
                    }
                    else {
                        print("---------------------------------[ READ ]-----------------------------------------\n")
                        print(string)
                        print("\n")
                        
                        return data
                    }
                    
                } catch {
                    print("Error when reading the socket")
                    return Data()
                }
            }
        }
        else {
            do {
                var data = Data()
                try socket.read(into: &data)
                data = data.dropFirst(4)
                return data
            } catch {
                print("Error when reading the socket")
                return Data()
            }
        }
    }
    
    //Return response from a "Ping" command, If it's OK, returns "OK", else, it's likely an error.
    public func ping() -> String {
        
        do {
            let socket = DaemonSocket().new()
            
            try socket.write(from: createrequest(request: "\"Ping\""))
            let data = DaemonSocket().dataRead(socket: socket)
            return String(decoding: data, as: UTF8.self)
            
                        
        } catch {
            print("Error")
            return "Error"
        }
    }
    
    public func send(command: String, socket: Socket) {
        if Config().debugMode {
            if Config().showStatusRequests {
                do {
                    try socket.write(from: createrequest(request: command))
                    print("---------------------------------[ SEND ]-----------------------------------------\n")
                    print(command)
                    print("\n")
                                
                } catch {
                    print("Error")
                }
            }
            else {
                do {
                    try socket.write(from: createrequest(request: command))
                    if command != "\"GetStatus\"" {
                        print("---------------------------------[ SEND ]-----------------------------------------\n")
                        print(command)
                        print("\n")
                    }
                                
                } catch {
                    print("Error")
                }
            }
        }
        else {
            do {
                try socket.write(from: createrequest(request: command))
                            
            } catch {
                print("Error")
            }

        }
    }
}


public struct GoXlr {
    //Now let's define a goxlr object.
    
    var device: String
    
    //Daemon needs to know to wich goxlr he has to send the command, let's init the struct with the wanted serial.
    public init(serial:String? = "") {
        device = serial ?? ""
    }
    
//--------------------------------[Status]-------------------------------------------------//

    //Returns a JSON with complete status of the goxlr.
    public func status() -> daemonStatus? {
        do {
            let socket = DaemonSocket().new()
            
            DaemonSocket().send(command: "\"GetStatus\"", socket: socket)
            let decoder = JSONDecoder()
            decoder.keyDecodingStrategy = .useDefaultKeys
            
            return try decoder.decode(daemonStatus.self, from: DaemonSocket().dataRead(socket: socket))
                        
        } catch {
            print(error)
            return nil
        }
    }
    
    
    public func deviceStatus() -> Mixer? {
        do {
            let socket = DaemonSocket().new()
            
            DaemonSocket().send(command: "\"GetStatus\"", socket: socket)

            let state = try JSONDecoder().decode(daemonStatus.self, from: DaemonSocket().dataRead(socket: socket))
            
            if self.device == "" { return state.status.mixers.first!.1 }
            else { return state.status.mixers[device] }
            
                        
        } catch {
            print("Error")
            return nil
        }
    }
    
    
    
    //--------------------------------[Gettrs]-------------------------------------------------//

    
    public func listDevices() -> [[String]]{
        var devices: [[String]] = []
        
        for i in self.status()!.status.mixers {
            devices.append([i.0, i.1.hardware.deviceType])
        }
        return devices
    }
    
    public func deviceType() -> Model {
        var mixertype: String
        if self.device == "" { mixertype = self.status()!.status.mixers.first!.1.hardware.deviceType }
        else { mixertype = self.status()!.status.mixers[device]!.hardware.deviceType }
        
        if mixertype == "Full" {
            return .Full
        }
        else {
            return .Mini
        }
    }
    
    public func faderAssignements(fader: FaderName) -> ChannelName {
        let faderstatusesmixer = self.status()!.status.mixers
        let faderstatuses: [FaderStatus]
        if self.device == "" { faderstatuses = faderstatusesmixer.first!.1.faderStatus }
        else { faderstatuses = faderstatusesmixer[device]!.faderStatus }
        if fader == .A { return faderstatuses[0].channel }
        else if fader == .B { return faderstatuses[1].channel }
        else if fader == .C { return faderstatuses[2].channel }
        else if fader == .D { return faderstatuses[3].channel }
        else { return .Mic }
    }
    
    public func muteBehaviour(fader: FaderName) -> MuteFunction {
        let faderstatusesmixer = self.status()!.status.mixers
        let faderstatuses: [FaderStatus]
        if self.device == "" { faderstatuses = faderstatusesmixer.first!.1.faderStatus }
        else { faderstatuses = faderstatusesmixer[device]!.faderStatus }
        if fader == .A { return faderstatuses[0].muteType }
        else if fader == .B { return faderstatuses[1].muteType }
        else if fader == .C { return faderstatuses[2].muteType }
        else if fader == .D { return faderstatuses[3].muteType }
        else { return .All }
    }
    
    public func channelVolume(channel: ChannelName) -> Float {
        let allvolumes = self.status()!.status.mixers
        let volumes: [Int]
        if self.device == "" { volumes = allvolumes.first!.1.levels.volumes }
        else { volumes = allvolumes[device]!.levels.volumes }
        
        if channel == .Mic { return Float(volumes[0]) }
        else if channel == .LineIn { return Float(volumes[1]) }
        else if channel == .Console { return Float(volumes[2]) }
        else if channel == .System { return Float(volumes[3]) }
        else if channel == .Game { return Float(volumes[4]) }
        else if channel == .Chat { return Float(volumes[5]) }
        else if channel == .Sample { return Float(volumes[6]) }
        else if channel == .Music { return Float(volumes[7]) }
        else if channel == .Headphones { return Float(volumes[8]) }
        else if channel == .MicMonitor { return Float(volumes[9]) }
        else if channel == .LineOut { return Float(volumes[10]) }
        else { return 0 }
    }
    
    public func allChannelVolume() -> [ChannelName: Float] {
        let allvolumes = self.status()!.status.mixers
        let volumes: [Int]
        if self.device == "" { volumes = allvolumes.first!.1.levels.volumes }
        else { volumes = allvolumes[device]!.levels.volumes }
        var allVol: [ChannelName:Float] = [:]
        
        allVol[.Mic] = Float(volumes[0])
        allVol[.LineIn] = Float(volumes[1])
        
        allVol[.Console] = Float(volumes[2])
        allVol[.System] = Float(volumes[3])
        allVol[.Game] = Float(volumes[4])
        allVol[.Chat] = Float(volumes[5])
        allVol[.Sample] = Float(volumes[6])
        allVol[.Music] = Float(volumes[7])
        allVol[.Headphones] = Float(volumes[8])
        allVol[.MicMonitor] = Float(volumes[9])
        allVol[.LineOut] = Float(volumes[10])
        print(allVol)
        return allVol
               

    }
    
    
    public func bleepVolume() -> Int {
        let allbleepvolume = self.status()!.status.mixers
        var bleepvolume = 0
        if self.device == "" { bleepvolume = allbleepvolume.first!.1.levels.bleep }
        else { bleepvolume = allbleepvolume[device]!.levels.bleep }
        return bleepvolume
    }
    
//--------------------------------[Debug]-------------------------------------------------//

    public func copyDebugInfo() {
        let status = self.status()
        let daemonPing = DaemonSocket().ping() ?? "Null"
        let devicesList = self.listDevices().description
        var audioDevices = ""
        for device in simplyCA.allDevices {
            audioDevices = audioDevices + "\(device.name) : aggregate: \(device.isAggregateDevice), id: \(device.id), isDefaultInputDevice: \(device.isDefaultInputDevice), isDefaultOutputDevice: \(device.isDefaultOutputDevice), isInputOnly: \(device.isInputOnlyDevice), isOutputOnly : \(device.isOutputOnlyDevice), prefferedChannelsForInput: \(device.preferredChannelsForStereo(scope: .input)), prefferedChannelsForOutput: \(device.preferredChannelsForStereo(scope: .output)); \n\n"
        }
        let returnValue = """
                        ✧──────────────・「 Debug Info 」・──────────────✧
                        ・ Daemon ping : \(daemonPing)
                        
                        ・ Device list : \(devicesList)
                        
                        ・ Status JSON :
                        
                        \(status)
                        
                        ・ All audio devices :
                        
                        \(audioDevices)
                        
                        ✧───────────────────────────────────────────────✧
                        """
        let pasteBoard = NSPasteboard.general
        pasteBoard.clearContents()
        pasteBoard.setString(returnValue, forType: .string)

    }
    
//--------------------------------[Commands]-------------------------------------------------//
    
    public func Command(command:String) -> JSON {
        //Send a json string to the socket directly.
        
        do {
            let socket = DaemonSocket().new()
            
            DaemonSocket().send(command: command, socket: socket)

            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("Command Error")
            return "Command Error"
        }
    }

    //--------------------------------[Mixer]-------------------------------------------------//

    public func SetFader(fader:FaderName, channel: ChannelName) -> JSON {
        //Set fader assignement by sending the fader name (A, B, C, D) and channel name.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetFader\":[\"\(fader)\",\"\(channel)\"]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetFader Error")
            return "SetFader Error"
        }
    }
    
    public func SetFaderMuteFunction(faderName: FaderName, MuteFunction: MuteFunction) -> JSON {
        //Set mute behaviour of the mute button of a given fader.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetFaderMuteFunction\":[\"\(faderName)\",\"\(MuteFunction)\"]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetFaderMuteFunction Error")
            return "SetFaderMuteFunction Error"
        }
    }
    
    public func SetVolume(channel: ChannelName, volume: Int) -> JSON {
        //Set volume of a given channel.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetVolume\":[\"\(channel)\",\(volume)]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetVolume Error")
            return "SetVolume Error"
        }
    }
    
    public func SetMicrophoneGain(microphoneType: MicrophoneType, gain: Int) -> JSON {
        //Set gain of a given mic type (Jack, Dynamic, Condenser)
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetMicrophoneGain\":[\"\(microphoneType)\",\(gain)]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetMicrophoneGain Error")
            return "SetMicrophoneGain Error"
        }
    }
    
    public func SetRouter(inputDevice:InputDevice, outputDevice: OutputDevice, state: Bool) -> JSON {
        //Toggle router route with the input device, the output device, and the state you wanna set.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetRouter\":[\"\(inputDevice)\",\"\(outputDevice)\",\(state)]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetRouter Error")
            return "SetRouter Error"
        }
    }
    
    //--------------------------------[Cough]-------------------------------------------------//

    
    public func SetCoughMuteFunction(MuteFunction: MuteFunction) -> JSON {
        //Set cough function. Same list of mutefunctions as the setfadermutefunction.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetCoughMuteFunction\":\"\(MuteFunction)\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetFaderMuteFunction Error")
            return "SetFaderMuteFunction Error"
        }
    }
    
    public func SetCoughIsHold(state: Bool) -> JSON {
        //Set cough function. Same list of mutefunctions as the setfadermutefunction.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetCoughIsHold\":\(state)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetFaderMuteFunction Error")
            return "SetFaderMuteFunction Error"
        }
    }
    
    //--------------------------------[Bleep]-------------------------------------------------//

    public func SetSwearButtonVolume(volume: Int) -> JSON {
        //Set volume of the bleep button.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetSwearButtonVolume\":\(volume)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetFaderMuteFunction Error")
            return "SetFaderMuteFunction Error"
        }
    }
    //--------------------------------[EQ Settings]-------------------------------------------------//

    
    public func SetEqMiniGain(frequence:MiniEqFrequencies, gain: Int) -> JSON {
        //Set mini EQ gain for a given frequence.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetEqMiniGain\":[\"\(frequence)\",\(gain)]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetEqMiniGain Error")
            return "SetEqMiniGain Error"
        }
    }
    
    public func SetEqMiniFreq(frequence:MiniEqFrequencies, freq: Float32) -> JSON {
        //Set mini EQ frequence for a given frequence.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetEqMiniFreq\":[\"\(frequence)\",\(freq)]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetEqMiniFreq Error")
            return "SetEqMiniFreq Error"
        }
    }
    
    
    public func SetEqGain(frequence:EqFrequencies, gain: Int) -> JSON {
        //Set EQ gain for a given frequence.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetEqGain\":[\"\(frequence)\",\(gain)]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetEqGain Error")
            return "SetEqGain Error"
        }
    }
    
    public func SetEqFreq(frequence:EqFrequencies, freq: Float32) -> JSON {
        //Set EQ frequence for a given frequence.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetEqFreq\":[\"\(frequence)\",\(freq)]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetEqFreq Error")
            return "SetEqFreq Error"
        }
    }
    
    public func ResetEQ() {
        for freq in EqFrequencies.allCases {
            self.SetEqGain(frequence: freq, gain: 0)
        }
        self.SetEqFreq(frequence: .Equalizer31Hz, freq: 31)
        self.SetEqFreq(frequence: .Equalizer63Hz, freq: 63)
        self.SetEqFreq(frequence: .Equalizer125Hz, freq: 125)
        self.SetEqFreq(frequence: .Equalizer250Hz, freq: 250)
        self.SetEqFreq(frequence: .Equalizer500Hz, freq: 500)
        self.SetEqFreq(frequence: .Equalizer1KHz, freq: 1000)
        self.SetEqFreq(frequence: .Equalizer2KHz, freq: 2000)
        self.SetEqFreq(frequence: .Equalizer4KHz, freq: 4000)
        self.SetEqFreq(frequence: .Equalizer8KHz, freq: 8000)
        self.SetEqFreq(frequence: .Equalizer16KHz, freq: 16000)

    }
    
    public func ResetMiniEQ() {
        for freq in MiniEqFrequencies.allCases {
            self.SetEqMiniGain(frequence: freq, gain: 0)
        }
        self.SetEqMiniFreq(frequence: .Equalizer90Hz, freq: 90)
        self.SetEqMiniFreq(frequence: .Equalizer250Hz, freq: 250)
        self.SetEqMiniFreq(frequence: .Equalizer500Hz, freq: 500)
        self.SetEqMiniFreq(frequence: .Equalizer1KHz, freq: 1000)
        self.SetEqMiniFreq(frequence: .Equalizer3KHz, freq: 3000)
        self.SetEqMiniFreq(frequence: .Equalizer8KHz, freq: 8000)
    }
    
    public func setSimplifiedEq(type: Eqsliders, value: Int) {
        if type == .Bass {
            self.SetEqGain(frequence: .Equalizer31Hz, gain: value)
            self.SetEqGain(frequence: .Equalizer63Hz, gain: value)
            self.SetEqGain(frequence: .Equalizer125Hz, gain: value)
            self.SetEqGain(frequence: .Equalizer250Hz, gain: value)
        }
        else if type == .Mid {
            self.SetEqGain(frequence: .Equalizer500Hz, gain: value)
            self.SetEqGain(frequence: .Equalizer1KHz, gain: value)
            self.SetEqGain(frequence: .Equalizer2KHz, gain: value)
        }
        else {
            self.SetEqGain(frequence: .Equalizer4KHz, gain: value)
            self.SetEqGain(frequence: .Equalizer8KHz, gain: value)
            self.SetEqGain(frequence: .Equalizer16KHz, gain: value)
        }

    }
    
    public func setSimplifiedMiniEq(type: Eqsliders, value: Int) {
        if type == .Bass {
            self.SetEqMiniGain(frequence: .Equalizer90Hz, gain: value)
            self.SetEqMiniGain(frequence: .Equalizer250Hz, gain: value)
        }
        else if type == .Mid {
            self.SetEqMiniGain(frequence: .Equalizer500Hz, gain: value)
            self.SetEqMiniGain(frequence: .Equalizer1KHz, gain: value)
        }
        else {
            self.SetEqMiniGain(frequence: .Equalizer3KHz, gain: value)
            self.SetEqMiniGain(frequence: .Equalizer8KHz, gain: value)
        }

    }
    //--------------------------------[Gate Settings]-------------------------------------------------//

    public func SetGateThreshold(treshold: Int) -> JSON {
        //Set gate treshold
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetGateThreshold\":\(treshold)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetGateThreshold Error")
            return "SetGateThreshold Error"
        }
    }
    
    public func SetGateAttenuation(attenuation: Int) -> JSON {
        //Set gate treshold
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetGateAttenuation\":\(attenuation)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetGateAttenuation Error")
            return "SetGateAttenuation Error"
        }
    }
    
    public func SetGateAttack(attack: GateTimes) -> JSON {
        //Set gate attack with string (like Gate10ms min, Gate20ms, or Gate2000ms max)
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetGateAttack\":\(attack.index!)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetGateAttack Error")
            return "SetGateAttack Error"
        }
    }
    
    public func SetGateRelease(release: GateTimes) -> JSON {
        //Set gate release with string (like Gate10ms min, Gate20ms, or Gate2000ms max)
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetGateRelease\":\(release.index!)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetGateRelease Error")
            return "SetGateRelease Error"
        }
    }
    
    public func SetGateActive(state: Bool) -> JSON {
        //Toggle gate
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetGateActive\":\(state)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetGateActive Error")
            return "SetGateActive Error"
        }
    }
    
    public func SetGateAmount(amount: Double) {
        //set gate Amount
        print(amount)
        self.SetGateThreshold(treshold: Int(amount/100*59-59))
        print(amount/100*59-59)
        self.SetGateAttenuation(attenuation: Int(((amount / 100) * 50) + 50))
        print(((amount / 100) * 50) + 50)
        if amount == 0 {
            self.SetGateActive(state: false)
        }
        else {
            self.SetGateActive(state: true)
        }
    }
    //--------------------------------[De-esser Settings]-------------------------------------------------//
    
    public func SetDeEsser(amount: Int) -> JSON {
        //Set De-esser amount
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetDeeser\":\(amount)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetDeEsser Error")
            return "SetDeEsser Error"
        }
    }

    //--------------------------------[Gate Settings]-------------------------------------------------//

    
    public func SetCompressorThreshold(treshold: Int) -> JSON {
        //Set Compressor treshold
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetCompressorThreshold\":\(treshold)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetCompressorThreshold Error")
            return "SetCompressorThreshold Error"
        }
    }
    
    public func SetCompressorRatio(ratio: CompressorRatio) -> JSON {
        //Set compressor ratio with ratio string like Ratio1_0. Pasted comment from the rust ipc:
        
        /*
        Ok, before we get started with these next couple of enums, lemme explain how the GoXLR works for
        certain values. While the UI under windows appears to display a range, these values are all mapped
        to fixed values in an array (eg. goxlr_shared.h line 415), and the index of that value is sent to
        the GoXLR. This will most often occur for values that aren't linear, the ratio starts at increments
        of 0.1, and by the end it's hitting increments of 16 and 32.
        These enums are essentially the same maps, and use 'as usize' and strum::iter().nth to convert.
         */
        
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetCompressorRatio\":\(ratio.index!)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetCompressorRatio Error")
            return "SetCompressorRatio Error"
        }
    }
    
    
    public func SetCompressorAttack(attack: CompressorAttackTime) -> JSON {
        //Set compressor attack with attack time string like Comp0ms.
        // Note: 0ms is technically 0.001ms

        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetCompressorAttack\":\(attack.index!)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetCompressorAttack Error")
            return "SetCompressorAttack Error"
        }
    }
    
    public func SetCompressorReleaseTime(release: CompressorReleaseTime) -> JSON {
        //Set gate attack with comp time
        // Note: 0 is technically 15 :)

        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetCompressorReleaseTime\":\(release.index!)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetCompressorReleaseTime Error")
            return "SetCompressorReleaseTime Error"
        }
    }
    
    public func SetCompressorMakeupGain(gain: Int) -> JSON {
        //Set Compressor makeup gain with int parameter.
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetCompressorMakeupGain\":\(gain)}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetCompressorMakeupGain Error")
            return "SetCompressorMakeupGain Error"
        }
    }
    
    public func SetCompressorAmount(amount: Int) {
        self.SetCompressorThreshold(treshold: Int((Double(amount) / 100 * 40) - 40))
        self.SetCompressorRatio(ratio: Int((Double(amount) / 100 * 14)).GetCompRatio())
    }
    
    //--------------------------------[Color related Settings]-------------------------------------------------//

    
    public func SetFaderDisplayStyle(faderName: FadersLightning, displayStyle: FaderDisplayStyle) -> JSON {
        //Set fader display style
        
        if faderName == .All {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetAllFaderDisplayStyle\":\"\(displayStyle)\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
        }
        else {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetFaderDisplayStyle\":[\"\(faderName)\",\"\(displayStyle)\"]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
        }
    }
    
    public func SetFaderColours(faderName: FadersLightning, colourTop: String, colourBottom: String) -> JSON {
        //Set colours of a specified fader
        
        
        if faderName == .All {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetAllFaderColours\":[\"\(colourTop)\", \"\(colourBottom)\"]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
        }
        else {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetFaderColours\":[\"\(faderName)\",\"\(colourTop)\", \"\(colourBottom)\"]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
        }
    }
    
    public func SetAllFaderColours(colourTop: String, colourBottom: String) -> JSON {
        //Set all fader colours
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetAllFaderColours\":[\"\(colourTop)\", \"\(colourBottom)\"]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetAllFaderColours Error")
            return "SetAllFaderColours Error"
        }
    }
    
    
    
    
    public func SetButtonColours(button: ButtonColourTargets, colour1: String, colour2: String? = nil) -> JSON {
        //Set colours of a specified button
        
        do {
            let socket = DaemonSocket().new()
            if colour2 == nil {
                let request = "{\"Command\":[\"\(device)\",{\"SetButtonColours\":[\"\(button)\",\"\(colour1)\"]}]}"
                DaemonSocket().send(command: request, socket: socket)
            }
            else {
                let request = "{\"Command\":[\"\(device)\",{\"SetButtonColours\":[\"\(button)\",\"\(colour1)\", \"\(colour2!)\"]}]}"
                DaemonSocket().send(command: request, socket: socket)
            }
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetButtonColours Error")
            return "SetButtonColours Error"
        }
    }
    
    
    public func SetButtonOffStyle(button: ButtonColourTargets, style: ButtonColourOffStyle) -> JSON {
        //Set all fader colours
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetButtonOffStyle\":[\"\(button)\", \"\(style)\"]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetButtonOffStyle Error")
            return "SetButtonOffStyle Error"
        }
    }
    
    public func SetButtonGroupColours(group: ButtonColourGroups, colour1: String, colour2: String? = nil) -> JSON {
        //Set colours of a specified button
        
        do {
            let socket = DaemonSocket().new()
            if colour2 == nil {
                let request = "{\"Command\":[\"\(device)\",{\"SetButtonGroupColours\":[\"\(group)\",\"\(colour1)\"]}]}"
                DaemonSocket().send(command: request, socket: socket)
            }
            else {
                let request = "{\"Command\":[\"\(device)\",{\"SetButtonGroupColours\":[\"\(group)\",\"\(colour1)\", \"\(colour2!)\"]}]}"
                DaemonSocket().send(command: request, socket: socket)
            }
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetButtonGroupColours Error")
            return "SetButtonGroupColours Error"
        }
    }
    
    public func SetButtonGroupOffStyle(group: ButtonColourGroups, style: ButtonColourOffStyle) -> JSON {
        //Set all fader colours
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetButtonGroupOffStyle\":[\"\(group)\", \"\(style)\"]}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetButtonGroupOffStyle Error")
            return "SetButtonGroupOffStyle Error"
        }
    }
    
    //--------------------------------[Profiles]-------------------------------------------------//

    
    
    public func LoadProfile(path:String) -> JSON {
        //Load profile at path
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"LoadProfile\":\"\(path)\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("LoadProfile Error")
            return "LoadProfile Error"
        }
    }
    
    public func Sleep() -> JSON {
        return self.LoadProfile(path: "Sleep")
    }
    
    public func SaveProfile() -> JSON {
        //Save profile
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SaveProfile\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("LoadProfile Error")
            return "LoadProfile Error"
        }
    }
    
    public func SaveProfileAs(name:String) -> JSON {
        //Save profile with name
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SaveProfileAs\":\"\(name)\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SaveProfileAs Error")
            return "SaveProfileAs Error"
        }
    }
    
    public func NewProfile(name:String) -> JSON {
        //Save profile with name
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"NewProfile\":\"\(name)\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("NewProfile Error")
            return "NewProfile Error"
        }
    }
    
    public func DeleteProfile(name:String) -> JSON {
        //Load profile at path
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"DeleteProfile\":\"\(name)\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("DeleteProfile Error")
            return "DeleteProfile Error"
        }
    }
    
    public func LoadMicProfile(path:String) -> JSON {
        //Load mic profile at path
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"LoadMicProfile\":\"\(path)\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("LoadMicProfile Error")
            return "LoadMicProfile Error"
        }
    }
    
    public func SaveMicProfile() -> JSON {
        //Save mic profile at path
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SaveMicProfile\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SaveMicProfile Error")
            return "SaveMicProfile Error"
        }
    }
    
    public func SaveMicProfileAs(name:String) -> JSON {
        //Save profile with name
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SaveMicProfileAs\":\"\(name)\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SaveMicProfileAs Error")
            return "SaveMicProfileAs Error"
        }
    }
    public func NewMicProfile(name:String) -> JSON {
        //Save profile with name
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"NewMicProfile\":\"\(name)\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("NewMicProfile Error")
            return "NewMicProfile Error"
        }
    }
    
    public func DeleteMicProfile(name:String) -> JSON {
        //Load profile at path
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"DeleteMicProfile\":\"\(name)\"}]}"
            DaemonSocket().send(command: request, socket: socket)
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("DeleteMicProfile Error")
            return "DeleteMicProfile Error"
        }
    }
}
