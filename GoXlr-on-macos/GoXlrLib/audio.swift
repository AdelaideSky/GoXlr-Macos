//
//  audio.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 24/07/2022.
//

import Foundation
import AVFAudio
import AVFoundation

public func getGoXlrAD() -> AVCaptureDevice? {
    let devices = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInMicrophone], mediaType: .audio, position: .unspecified).devices
    for device in devices {
        if device.localizedName == "GoXLR" {
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
