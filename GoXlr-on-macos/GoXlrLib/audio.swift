//
//  audio.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 24/07/2022.
//

import Foundation
import AVFAudio
import AVFoundation
import SimplyCoreAudio

public func getGoXlrAD() -> AVCaptureDevice? {
    let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone], mediaType: .audio, position: .unspecified).devices
    for device in devices {
        if device.localizedName == "GoXLR" {
            return device
        }
        else if device.localizedName == "GoXLRMini" {
            return device
        }
    }
    
    return nil
}

public func goXlrCaptureSession() -> AVCaptureSession {
        
    let captureSession = AVCaptureSession()
    let audioDevice = AVCaptureDevice.default(for: .audio)
    let audioOutput = AVCaptureAudioDataOutput()
    do {
        // Wrap the audio device in a capture device input.
        let audioInput = try AVCaptureDeviceInput(device: getGoXlrAD()!)
        // If the input can be added, add it to the session.
        if captureSession.canAddInput(audioInput) {
            captureSession.addInput(audioInput)
        }
        captureSession.addOutput(audioOutput)
    } catch {
        // Configuration failed. Handle error.
        print("DAZ WAS A ERROR")
        }
    return captureSession
}

public func AudioSetup(model: Model) -> Bool {
    print("Starting audio setup...")
    let listdevices = simplyCA.allNonAggregateDevices
    
    for device in listdevices {
        if device.name == model.audioDeviceName() {
            let goxlr = device
            print("found device \(device.description)")
            print("setting hog mode...")
            goxlr.setHogMode()
            
            print("Setting up System...")
            let system = simplyCA.createAggregateDevice(masterDevice: goxlr, secondDevice: goxlr, named: "System", uid: String("system:"+UUID().uuidString.dropLast(28)))
            system?.setPreferredChannelsForStereo(channels: StereoPair(left: 1, right: 2), scope: Scope.output)
            system?.setPreferredChannelsForStereo(channels: StereoPair(left: 0, right: 0), scope: Scope.input)
            print("Setting up Game...")
            let game = simplyCA.createAggregateDevice(masterDevice: goxlr, secondDevice: goxlr, named: "Game", uid: String("game:"+UUID().uuidString.dropLast(28)))
            game?.setPreferredChannelsForStereo(channels: StereoPair(left: 3, right: 4), scope: Scope.output)
            game?.setPreferredChannelsForStereo(channels: StereoPair(left: 0, right: 0), scope: Scope.input)
            print("Setting up Chat...")
            let chat = simplyCA.createAggregateDevice(masterDevice: goxlr, secondDevice: goxlr, named: "Chat", uid: String("chat:"+UUID().uuidString.dropLast(28)))
            chat?.setPreferredChannelsForStereo(channels: StereoPair(left: 5, right: 6), scope: Scope.output)
            chat?.setPreferredChannelsForStereo(channels: StereoPair(left: 0, right: 0), scope: Scope.input)
            print("Setting up Music...")
            let music = simplyCA.createAggregateDevice(masterDevice: goxlr, secondDevice: goxlr, named: "Music", uid: String("music:"+UUID().uuidString.dropLast(28)))
            music?.setPreferredChannelsForStereo(channels: StereoPair(left: 7, right: 8), scope: Scope.output)
            music?.setPreferredChannelsForStereo(channels: StereoPair(left: 0, right: 0), scope: Scope.input)
            if model == .Full {
                print("Setting up Sampler Source...")
                let sample = simplyCA.createAggregateDevice(masterDevice: goxlr, secondDevice: goxlr, named: "Sample", uid: String("sample:"+UUID().uuidString.dropLast(28)))
                sample?.setPreferredChannelsForStereo(channels: StereoPair(left: 9, right: 10), scope: Scope.output)
                sample?.setPreferredChannelsForStereo(channels: StereoPair(left: 0, right: 0), scope: Scope.input)
            }
            
            print("Setting up Broadcast Mix...")
            let broadcastMix = simplyCA.createAggregateDevice(masterDevice: goxlr, secondDevice: goxlr, named: "Broadcast mix", uid: String("broadcastmix:"+UUID().uuidString.dropLast(28)))
            broadcastMix?.setPreferredChannelsForStereo(channels: StereoPair(left: 1, right: 2), scope: Scope.input)
            broadcastMix?.setPreferredChannelsForStereo(channels: StereoPair(left: 0, right: 0), scope: Scope.output)
            
            print("Setting up Chat Mic...")
            let chatMic = simplyCA.createAggregateDevice(masterDevice: goxlr, secondDevice: goxlr, named: "Chat mic", uid: String("chatmix:"+UUID().uuidString.dropLast(28)))
            chatMic?.setPreferredChannelsForStereo(channels: StereoPair(left: 3, right: 4), scope: Scope.input)
            chatMic?.setPreferredChannelsForStereo(channels: StereoPair(left: 0, right: 0), scope: Scope.output)
            
            print("Setting default audio device...")
            system?.isDefaultOutputDevice = true
            chatMic?.isDefaultInputDevice = true
            print("Unset Hog Mode...")
            goxlr.unsetHogMode()
        }
    }
    print("Finished Audio Setup")
    return false
}
