//
//  fxStatus.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 29/08/2022.
//

import Foundation

final public class FxStatus: ObservableObject {
    
    
    @Published var micSetup = false
    @Published var profileSheet = false
    @Published var coughSheet = false
    
    
    var selectedDevice: GoXlr
    var status: Mixer
    
    public init() {
        selectedDevice = GoXlr(serial: GoXlr().listDevices()[0].first)
        status = selectedDevice.deviceStatus()!
        let completestatus = selectedDevice.status()!.status
        let fxStatus = status.effects!
        
    }
    public func update() {
        status = selectedDevice.deviceStatus()!
        let completestatus = selectedDevice.status()!.status
        let fxStatus = status.effects!
    }
}
