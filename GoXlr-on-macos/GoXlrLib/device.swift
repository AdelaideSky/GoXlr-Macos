import SwiftUI
import Socket
import Foundation
import SwiftyJSON

//--------------------------------[Extensions]-------------------------------------------------//

extension Data {
    var bytes: [UInt8] {
        return [UInt8](self)
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

//Creating header with the last byte equal to length of the request
//RE-WRITE THIS FUNC bcause with this version length is limited to 255 + uses lots of funcs
func createrequest(request: String) -> Data {
    let len = String(format: "%02X", request.count)
    let hexlen = hexStringToData(string: len).bytes
    let header = [0x00, 0x00, 0x00, hexlen[0]]
    let body = Data(request.utf8)
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
    public func dataRead(socket: Socket) -> Data {
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
    
    //Return response from a "Ping" command, If it's OK, returns "OK", else, it's likely an error.
    public func ping() -> JSON {
        do {
            let socket = DaemonSocket().new()
            
            try socket.write(from: createrequest(request: "\"Ping\""))
            return DaemonSocket().read(socket: socket)
                        
        } catch {
            print("Error")
            return "Error"
        }
    }
}


public struct GoXlr {
    //Now let's devine a goxlr object.
    
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
            
            try socket.write(from: createrequest(request: "\"GetStatus\""))
            
            return try JSONDecoder().decode(daemonStatus.self, from: DaemonSocket().dataRead(socket: socket))
                        
        } catch {
            print("Error")
            return nil
        }
    }
    
    public func deviceStatus() -> Mixer? {
        do {
            let socket = DaemonSocket().new()
            
            try socket.write(from: createrequest(request: "\"GetStatus\""))
            
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
        if self.device == "" { volumes = allvolumes.first!.1.volumes }
        else { volumes = allvolumes[device]!.volumes }
        
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
        if self.device == "" { volumes = allvolumes.first!.1.volumes }
        else { volumes = allvolumes[device]!.volumes }
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
        if self.device == "" { bleepvolume = allbleepvolume.first!.1.bleepVolume }
        else { bleepvolume = allbleepvolume[device]!.bleepVolume }
        return bleepvolume
    }
    
//--------------------------------[Commands]-------------------------------------------------//
    
    public func Command(command:String) -> JSON {
        //Send a json string to the socket directly.
        
        do {
            let socket = DaemonSocket().new()
            
            try socket.write(from: createrequest(request: command))
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
            try socket.write(from: createrequest(request: request))
            MixerStatus().sliderC = .Mic
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetEqFreq Error")
            return "SetEqFreq Error"
        }
    }
    //--------------------------------[Gate Settings]-------------------------------------------------//

    public func SetGateThreshold(treshold: Int) -> JSON {
        //Set gate treshold
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetGateThreshold\":\(treshold)}]}"
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            let request = "{\"Command\":[\"\(device)\",{\"SetGateAttack\":\"\(attack)\"}]}"
            try socket.write(from: createrequest(request: request))
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
            let request = "{\"Command\":[\"\(device)\",{\"SetGateRelease\":\"\(release)\"}]}"
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetGateActive Error")
            return "SetGateActive Error"
        }
    }
    //--------------------------------[Gate Settings]-------------------------------------------------//

    
    public func SetCompressorThreshold(treshold: Int) -> JSON {
        //Set Compressor treshold
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetCompressorThreshold\":\(treshold)}]}"
            try socket.write(from: createrequest(request: request))
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
            let request = "{\"Command\":[\"\(device)\",{\"SetCompressorRatio\":\"\(ratio)\"}]}"
            try socket.write(from: createrequest(request: request))
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
            let request = "{\"Command\":[\"\(device)\",{\"SetCompressorAttack\":\"\(attack)\"}]}"
            try socket.write(from: createrequest(request: request))
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetCompressorAttack Error")
            return "SetCompressorAttack Error"
        }
    }
    
    public func SetCompressorReleaseTime(release: CompressorReleaseTime) -> JSON {
        //Set gate attack with string (like Gate10ms min, Gate20ms, or Gate2000ms max)
        // Note: 0 is technically 15 :)

        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetCompressorReleaseTime\":\"\(release)\"}]}"
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetCompressorMakeupGain Error")
            return "SetCompressorMakeupGain Error"
        }
    }
    
    //--------------------------------[Color related Settings]-------------------------------------------------//

    
    public func SetFaderDisplayStyle(faderName: FaderName, displayStyle: FaderDisplayStyle) -> JSON {
        //Set fader display style
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetFaderDisplayStyle\":[\"\(faderName)\",\"\(displayStyle)\"]}]}"
            try socket.write(from: createrequest(request: request))
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetFaderDisplayStyle Error")
            return "SetFaderDisplayStyle Error"
        }
    }
    
    public func SetAllFaderDisplayStyle(displayStyle: FaderDisplayStyle) -> JSON {
        //Set fader all display style
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetAllFaderDisplayStyle\":\"\(displayStyle)\"}]}"
            try socket.write(from: createrequest(request: request))
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetAllFaderDisplayStyle Error")
            return "SetAllFaderDisplayStyle Error"
        }
    }
    
    public func SetFaderColours(faderName: FaderName, colour1: String, colour2: String) -> JSON {
        //Set colours of a specified fader
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetFaderColours\":[\"\(faderName)\",\"\(colour1)\", \"\(colour2)\"]}]}"
            try socket.write(from: createrequest(request: request))
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SetFaderColours Error")
            return "SetFaderColours Error"
        }
    }
    
    public func SetAllFaderColours(colour1: String, colour2: String) -> JSON {
        //Set all fader colours
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"SetAllFaderColours\":[\"\(colour1)\", \"\(colour2)\"]}]}"
            try socket.write(from: createrequest(request: request))
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
                try socket.write(from: createrequest(request: request))
            }
            else {
                let request = "{\"Command\":[\"\(device)\",{\"SetButtonColours\":[\"\(button)\",\"\(colour1)\", \"\(colour2!)\"]}]}"
                try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
                try socket.write(from: createrequest(request: request))
            }
            else {
                let request = "{\"Command\":[\"\(device)\",{\"SetButtonGroupColours\":[\"\(group)\",\"\(colour1)\", \"\(colour2!)\"]}]}"
                try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
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
            let request = "{\"Command\":[\"\(device)\",{\"LoadProfile\":\"\"}]}"
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SaveProfileAs Error")
            return "SaveProfileAs Error"
        }
    }
    
    
    public func LoadMicProfile(path:String) -> JSON {
        //Load mic profile at path
        
        do {
            let socket = DaemonSocket().new()
            let request = "{\"Command\":[\"\(device)\",{\"LoadMicProfile\":\"\(path)\"}]}"
            try socket.write(from: createrequest(request: request))
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
            let request = "{\"Command\":[\"\(device)\",{\"SaveMicProfile\":\"\"}]}"
            try socket.write(from: createrequest(request: request))
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
            try socket.write(from: createrequest(request: request))
            return JSON(DaemonSocket().read(socket: socket))
                        
        } catch {
            print("SaveMicProfileAs Error")
            return "SaveMicProfileAs Error"
        }
    }
}
