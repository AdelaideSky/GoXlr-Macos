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
    
    var selectedDevice = GoXlr(serial: GoXlr().listDevices()[0].first)
    @Published var deviceSelect: String = "Select a goxlr" {
        willSet {
            selectedDevice = GoXlr(serial: newValue)
        }
    }
    //--------------------------------[SLIDERS - Mixer]-------------------------------------------------//
    
    @Published var mic: Float = GoXlr().channelVolume(channel: .Mic) {
        willSet { _ = selectedDevice.SetVolume(channel: .Mic, volume: Int(newValue)) } }
    @Published var chat: Float = GoXlr().channelVolume(channel: .Chat) {
        willSet { _ = selectedDevice.SetVolume(channel: .Chat, volume: Int(newValue)) } }
    @Published var music: Float = GoXlr().channelVolume(channel: .Music) {
        willSet { _ = selectedDevice.SetVolume(channel: .Music, volume: Int(newValue)) } }
    @Published var game: Float = GoXlr().channelVolume(channel: .Game) {
        willSet { _ = selectedDevice.SetVolume(channel: .Game, volume: Int(newValue)) } }
    @Published var console: Float = GoXlr().channelVolume(channel: .Console) {
        willSet { _ = selectedDevice.SetVolume(channel: .Console, volume: Int(newValue)) } }
    @Published var linein: Float = GoXlr().channelVolume(channel: .LineIn) {
        willSet { _ = selectedDevice.SetVolume(channel: .LineIn, volume: Int(newValue)) } }
    @Published var lineout: Float = GoXlr().channelVolume(channel: .LineOut) {
        willSet { _ = selectedDevice.SetVolume(channel: .LineOut, volume: Int(newValue)) } }
    @Published var system: Float = GoXlr().channelVolume(channel: .System) {
        willSet { _ = selectedDevice.SetVolume(channel: .System, volume: Int(newValue)) } }
    @Published var sample: Float = GoXlr().channelVolume(channel: .Sample) {
        willSet { _ = selectedDevice.SetVolume(channel: .Sample, volume: Int(newValue)) } }
    @Published var bleep: Float = 0 {
        willSet { _ = selectedDevice.SetSwearButtonVolume(volume: Int(newValue)) } }
    @Published var headphones: Float = GoXlr().channelVolume(channel: .Headphones) {
        willSet { _ = selectedDevice.SetVolume(channel: .Headphones, volume: Int(newValue)) } }
    @Published var micmonitor: Float = GoXlr().channelVolume(channel: .MicMonitor) {
        willSet { _ = selectedDevice.SetVolume(channel: .MicMonitor, volume: Int(newValue)) } }
    
    
    @Published var sliderA: ChannelName = GoXlr().faderAssignements(fader: .A) {
        didSet { _ = selectedDevice.SetFader(fader: .A, channel: sliderA)} }
    @Published var sliderB: ChannelName = GoXlr().faderAssignements(fader: .B) {
        didSet { _ = selectedDevice.SetFader(fader: .B, channel: sliderB)} }
    @Published var sliderC: ChannelName = GoXlr().faderAssignements(fader: .C) {
        didSet { _ = selectedDevice.SetFader(fader: .C, channel: sliderC)} }
    @Published var sliderD: ChannelName = GoXlr().faderAssignements(fader: .D) {
        didSet { _ = selectedDevice.SetFader(fader: .D, channel: sliderD)} }

    @Published var muteA: MuteFunction = GoXlr().muteBehaviour(fader: .A) {
        willSet { _ = selectedDevice.SetFaderMuteFunction(faderName: .A, MuteFunction: newValue)} }
    @Published var muteB: MuteFunction = GoXlr().muteBehaviour(fader: .B) {
        willSet { _ = selectedDevice.SetFaderMuteFunction(faderName: .B, MuteFunction: newValue)} }
    @Published var muteC: MuteFunction = GoXlr().muteBehaviour(fader: .C) {
        willSet { _ = selectedDevice.SetFaderMuteFunction(faderName: .C, MuteFunction: newValue)} }
    @Published var muteD: MuteFunction = GoXlr().muteBehaviour(fader: .D) {
        willSet { _ = selectedDevice.SetFaderMuteFunction(faderName: .D, MuteFunction: newValue)} }

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

