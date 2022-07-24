//
//  Status.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 05/07/2022.
//

import SwiftUI
import Socket
import Foundation
import SwiftyJSON


final class MixerStatus: ObservableObject {
    
    @Published var micSetup = false
    
    var selectedDevice: GoXlr
    var status: Mixer
    
    public init() {
        selectedDevice = GoXlr(serial: GoXlr().listDevices()[0].first)
        status = selectedDevice.deviceStatus()!
        mic = Float(status.levels.volumes[0])
        chat = Float(status.levels.volumes[5])
        music = Float(status.levels.volumes[7])
        game = Float(status.levels.volumes[4])
        console = Float(status.levels.volumes[2])
        linein = Float(status.levels.volumes[1])
        lineout = Float(status.levels.volumes[10])
        system = Float(status.levels.volumes[3])
        sample = Float(status.levels.volumes[6])
        bleep = Float(status.levels.bleep)
        headphones = Float(status.levels.volumes[8])
        micmonitor = Float(status.levels.volumes[9])
        
        sliderA = status.faderStatus[0].channel
        sliderB = status.faderStatus[1].channel
        sliderC = status.faderStatus[2].channel
        sliderD = status.faderStatus[3].channel
        
        muteA = status.faderStatus[0].muteType
        muteB = status.faderStatus[1].muteType
        muteC = status.faderStatus[2].muteType
        muteD = status.faderStatus[3].muteType
        
        // ---- Mic ----
        
        micType = status.micStatus.micType
        
        if status.micStatus.micType == .Dynamic {activeGain = Float(status.micStatus.micGains[0])}
        else if status.micStatus.micType == .Condenser {activeGain = Float(status.micStatus.micGains[1])}
        else {activeGain = Float(status.micStatus.micGains[2])}

        dynamicGain = Float(status.micStatus.micGains[0])
        condenserGain = Float(status.micStatus.micGains[1])
        jackGain = Float(status.micStatus.micGains[2])

        deEsser = Float(status.levels.deess)
        
        gateThreshold = Float(status.micStatus.noiseGate.threshold)
        gateAttenuation = Float(status.micStatus.noiseGate.attenuation)
        gateAttack = Float(status.micStatus.noiseGate.attack.GetIntGateTime())
        gateRelease = Float(status.micStatus.noiseGate.release.GetIntGateTime())
        
        eqBass = Float(status.micStatus.equaliser.gain.bassValue())
        eqMid = Float(status.micStatus.equaliser.gain.midValue())
        eqTremble = Float(status.micStatus.equaliser.gain.trembleValue())

    }
    public func updateMixerStatus() {
        status = selectedDevice.deviceStatus()!
        mic = Float(status.levels.volumes[0])
        chat = Float(status.levels.volumes[5])
        music = Float(status.levels.volumes[7])
        game = Float(status.levels.volumes[4])
        console = Float(status.levels.volumes[2])
        linein = Float(status.levels.volumes[1])
        lineout = Float(status.levels.volumes[10])
        system = Float(status.levels.volumes[3])
        sample = Float(status.levels.volumes[6])
        bleep = Float(status.levels.bleep)
        headphones = Float(status.levels.volumes[8])
        micmonitor = Float(status.levels.volumes[9])
    }
    public func updateFaderDetails() {
        status = selectedDevice.deviceStatus()!
        sliderA = status.faderStatus[0].channel
        sliderB = status.faderStatus[1].channel
        sliderC = status.faderStatus[2].channel
        sliderD = status.faderStatus[3].channel
        
        muteA = status.faderStatus[0].muteType
        muteB = status.faderStatus[1].muteType
        muteC = status.faderStatus[2].muteType
        muteD = status.faderStatus[3].muteType
        
        eqBass = Float(status.micStatus.equaliser.gain.bassValue())
        eqMid = Float(status.micStatus.equaliser.gain.midValue())
        eqTremble = Float(status.micStatus.equaliser.gain.trembleValue())

    }
    
    public func updateMicDetails() {
        
        status = selectedDevice.deviceStatus()!
        
        micType = status.micStatus.micType
        
        if status.micStatus.micType == .Dynamic {activeGain = Float(status.micStatus.micGains[0])}
        else if status.micStatus.micType == .Condenser {activeGain = Float(status.micStatus.micGains[1])}
        else {activeGain = Float(status.micStatus.micGains[2])}

        dynamicGain = Float(status.micStatus.micGains[0])
        condenserGain = Float(status.micStatus.micGains[1])
        jackGain = Float(status.micStatus.micGains[2])
        
        deEsser = Float(status.levels.deess)
        
        gateThreshold = Float(status.micStatus.noiseGate.threshold)
        gateAttenuation = Float(status.micStatus.noiseGate.attenuation)
        gateAttack = Float(status.micStatus.noiseGate.attack.GetIntGateTime())
        gateRelease = Float(status.micStatus.noiseGate.release.GetIntGateTime())
    }
    @Published var deviceSelect: String = "Select a goxlr" {
        willSet {
            selectedDevice = GoXlr(serial: newValue)
        }
    }
    //--------------------------------[SLIDERS - Mixer]-------------------------------------------------//
    
    @Published var mic: Float
    @Published var chat: Float
    @Published var music: Float
    @Published var game: Float
    @Published var console: Float
    @Published var linein: Float
    @Published var lineout: Float
    @Published var system: Float
    @Published var sample: Float
    @Published var bleep: Float
    @Published var headphones: Float
    @Published var micmonitor: Float
    
    
    @Published var sliderA: ChannelName
    @Published var sliderB: ChannelName
    @Published var sliderC: ChannelName
    @Published var sliderD: ChannelName

    @Published var muteA: MuteFunction
    @Published var muteB: MuteFunction
    @Published var muteC: MuteFunction
    @Published var muteD: MuteFunction
    
    //--------------------------------[Mic types / gain - MIC]-----------------------------------------//

    @Published var micType: MicrophoneType
    
    @Published var activeGain: Float
    @Published var dynamicGain: Float
    @Published var condenserGain: Float
    @Published var jackGain: Float
    @Published var micLevel: Float = 0

    
    //--------------------------------[De-esser - MIC]-------------------------------------------------//
    
    @Published var deEsser: Float

    //--------------------------------[Noise Gate - MIC]-----------------------------------------------//
    
    @Published var gateThreshold: Float
    @Published var gateAttenuation: Float
    @Published var gateAttack: Float
    @Published var gateRelease: Float
    
    //--------------------------------[Equalizer - MIC]-----------------------------------------------//
    
    @Published var eqBass: Float
    @Published var eqMid: Float
    @Published var eqTremble: Float


}

func stringstatus() -> String {
    do {
        let socket = DaemonSocket().new()
        try socket.write(from: createrequest(request: "\"GetStatus\""))
        var data = Data()
        try socket.read(into: &data)
        return String(decoding: data.dropFirst(4), as: UTF8.self)
    } catch {
        print(error)
        return("error")
    }

}

func testingParsing() -> String {
        do {
            let socket = DaemonSocket().new()
            try socket.write(from: createrequest(request: "\"GetStatus\""))
            var data = Data()
            try socket.read(into: &data)
            data = data.dropFirst(4)
            
            return try JSONDecoder().decode(daemonStatus.self, from: data).status.mixers.first?.value.micProfileName ?? "ah"
            
                        
        } catch {
            print(error)
            return "error"
        }
}

func updateStatus() {
    MixerStatus().mic = GoXlr().channelVolume(channel: .Mic)
}
