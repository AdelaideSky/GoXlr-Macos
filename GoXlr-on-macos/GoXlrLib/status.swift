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
    
    
    var selectedDevice: GoXlr
    var status: Mixer
    
    public init() {
        selectedDevice = GoXlr(serial: GoXlr().listDevices()[0].first)
        status = selectedDevice.deviceStatus()!
        mic = Float(status.volumes[0])
        chat = Float(status.volumes[5])
        music = Float(status.volumes[7])
        game = Float(status.volumes[4])
        console = Float(status.volumes[2])
        linein = Float(status.volumes[1])
        lineout = Float(status.volumes[10])
        system = Float(status.volumes[3])
        sample = Float(status.volumes[6])
        bleep = Float(selectedDevice.bleepVolume())
        headphones = Float(status.volumes[8])
        micmonitor = Float(status.volumes[9])
        
        sliderA = status.faderStatus[0].channel
        sliderB = status.faderStatus[1].channel
        sliderC = status.faderStatus[2].channel
        sliderD = status.faderStatus[3].channel
        
        muteA = status.faderStatus[0].muteType
        muteB = status.faderStatus[1].muteType
        muteC = status.faderStatus[2].muteType
        muteD = status.faderStatus[3].muteType

    }
    public func updateMixerStatus() {
        status = selectedDevice.deviceStatus()!
        mic = Float(status.volumes[0])
        chat = Float(status.volumes[5])
        music = Float(status.volumes[7])
        game = Float(status.volumes[4])
        console = Float(status.volumes[2])
        linein = Float(status.volumes[1])
        lineout = Float(status.volumes[10])
        system = Float(status.volumes[3])
        sample = Float(status.volumes[6])
        bleep = Float(selectedDevice.bleepVolume())
        headphones = Float(status.volumes[8])
        micmonitor = Float(status.volumes[9])
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
