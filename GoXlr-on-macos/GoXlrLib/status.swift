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

var isdaemonLaunched = false


final public class MixerStatus: ObservableObject {
    
    
    @Published var micSetup = false
    @Published var profileSheet = false
    @Published var coughSheet = false
    
    @Published var lightningFadersSelected: FadersLightning = .All
    
    var selectedDevice: GoXlr
    var status: Mixer
    
    public init() {
        if !isdaemonLaunched {
            isdaemonLaunched = Daemon().start(args: nil)
        }
        selectedDevice = GoXlr(serial: GoXlr().listDevices()[0].first)
        status = selectedDevice.deviceStatus()!
        let completestatus = selectedDevice.status()!.status
        
        profilesList = completestatus.files.profiles
        profile = status.profileName
        selectedProfile = status.profileName
        
        micProfilesList = completestatus.files.micProfiles
        micProfile = status.micProfileName
        selectedMicProfile = status.micProfileName
        
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
        
        coughBehaviourIsHold = !status.coughButton.isToggle
        coughMuteBehaviour = status.coughButton.muteType
        
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
        
        gateAmount = Float((((status.micStatus.noiseGate.threshold + 59) * 100 / 59) + (status.micStatus.noiseGate.attenuation - 50)) * 100 / 150)
        
        eqBass = Float(status.micStatus.equaliser.gain.bassValue())
        eqMid = Float(status.micStatus.equaliser.gain.midValue())
        eqTremble = Float(status.micStatus.equaliser.gain.trembleValue())
        
        
        eq31Hz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer31Hz.rawValue]!)
        eq63Hz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer63Hz.rawValue]!)
        eq125Hz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer125Hz.rawValue]!)
        eq250Hz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer250Hz.rawValue]!)
        eq500Hz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer500Hz.rawValue]!)
        eq1KHz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer1KHz.rawValue]!)
        eq2KHz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer2KHz.rawValue]!)
        eq4KHz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer2KHz.rawValue]!)
        eq8KHz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer8KHz.rawValue]!)
        eq16KHz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer16KHz.rawValue]!)
        
        ft31Hz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer31Hz.rawValue]!)
        ft63Hz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer63Hz.rawValue]!)
        ft125Hz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer125Hz.rawValue]!)
        ft250Hz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer250Hz.rawValue]!)
        ft500Hz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer500Hz.rawValue]!)
        ft1KHz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer1KHz.rawValue]!)
        ft2KHz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer2KHz.rawValue]!)
        ft4KHz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer4KHz.rawValue]!)
        ft8KHz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer8KHz.rawValue]!)
        ft16KHz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer16KHz.rawValue]!)
        
        
        miniEqBass = Float(status.micStatus.equaliserMini.gain.miniBassValue())
        miniEqMid = Float(status.micStatus.equaliserMini.gain.miniMidValue())
        miniEqTremble = Float(status.micStatus.equaliserMini.gain.miniTrembleValue())
        
        miniEq90Hz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer90Hz.rawValue]!)
        miniEq250Hz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer250Hz.rawValue]!)
        miniEq500Hz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer500Hz.rawValue]!)
        miniEq1KHz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer1KHz.rawValue]!)
        miniEq3KHz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer3KHz.rawValue]!)
        miniEq8KHz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer8KHz.rawValue]!)
        
        miniFt90Hz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer90Hz.rawValue]!)
        miniFt250Hz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer250Hz.rawValue]!)
        miniFt500Hz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer500Hz.rawValue]!)
        miniFt1KHz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer1KHz.rawValue]!)
        miniFt3KHz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer3KHz.rawValue]!)
        miniFt8KHz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer8KHz.rawValue]!)
        
        
        compAmount = Float(((Double(status.micStatus.compressor.threshold + 40) * 100 / 40) + (Double(status.micStatus.compressor.ratio) * 100 / 14)) / 2)

        compThreshold = Float(status.micStatus.compressor.threshold)
        compAttack = Float(status.micStatus.compressor.attack.GetIntCompAtkTime())
        compRelease = Float(status.micStatus.compressor.release.GetIntCompRelTime())
        compRatio = Float(status.micStatus.compressor.ratio)
        compMakeUpGain = Float(status.micStatus.compressor.makeupGain)

        
        routerMic = status.routerTable[0]
        routerChat = status.routerTable[1]
        routerMusic = status.routerTable[2]
        routerGame = status.routerTable[3]
        routerConsole = status.routerTable[4]
        routerLineIn = status.routerTable[5]
        routerSystem = status.routerTable[6]
        routerSamples = status.routerTable[7]
        
       
        topFaderA = status.lighting.faders.a.colours.colourOne.toRGB().hsv
        brTopFaderA = status.lighting.faders.a.colours.colourOne.toRGB().hsv.v
        bottomFaderA = status.lighting.faders.a.colours.colourTwo.toRGB().hsv
        brBottomFaderA = status.lighting.faders.a.colours.colourTwo.toRGB().hsv.v
        
        buttonMuteAColour1 = status.lighting.buttons["Fader1Mute"]!.colours.colourOne.toRGB().hsv
        brButtonMuteAColour1 = status.lighting.buttons["Fader1Mute"]!.colours.colourOne.toRGB().hsv.v
        buttonMuteAColour2 = status.lighting.buttons["Fader1Mute"]!.colours.colourTwo.toRGB().hsv
        brButtonMuteAColour2 = status.lighting.buttons["Fader1Mute"]!.colours.colourTwo.toRGB().hsv.v

        styleFaderA = status.lighting.faders.a.style
        buttonMuteAStyle = status.lighting.buttons["Fader1Mute"]!.offStyle
        
        topFaderB = status.lighting.faders.b.colours.colourOne.toRGB().hsv
        brTopFaderB = status.lighting.faders.b.colours.colourOne.toRGB().hsv.v
        bottomFaderB = status.lighting.faders.b.colours.colourTwo.toRGB().hsv
        brBottomFaderB = status.lighting.faders.b.colours.colourTwo.toRGB().hsv.v
        
        buttonMuteBColour1 = status.lighting.buttons["Fader2Mute"]!.colours.colourOne.toRGB().hsv
        brButtonMuteBColour1 = status.lighting.buttons["Fader2Mute"]!.colours.colourOne.toRGB().hsv.v
        buttonMuteBColour2 = status.lighting.buttons["Fader2Mute"]!.colours.colourTwo.toRGB().hsv
        brButtonMuteBColour2 = status.lighting.buttons["Fader2Mute"]!.colours.colourTwo.toRGB().hsv.v
        
        styleFaderB = status.lighting.faders.b.style
        buttonMuteBStyle = status.lighting.buttons["Fader2Mute"]!.offStyle

        
        topFaderC = status.lighting.faders.c.colours.colourOne.toRGB().hsv
        brTopFaderC = status.lighting.faders.c.colours.colourOne.toRGB().hsv.v
        bottomFaderC = status.lighting.faders.c.colours.colourTwo.toRGB().hsv
        brBottomFaderC = status.lighting.faders.c.colours.colourTwo.toRGB().hsv.v
        
        buttonMuteCColour1 = status.lighting.buttons["Fader3Mute"]!.colours.colourOne.toRGB().hsv
        brButtonMuteCColour1 = status.lighting.buttons["Fader3Mute"]!.colours.colourOne.toRGB().hsv.v
        buttonMuteCColour2 = status.lighting.buttons["Fader3Mute"]!.colours.colourTwo.toRGB().hsv
        brButtonMuteCColour2 = status.lighting.buttons["Fader3Mute"]!.colours.colourTwo.toRGB().hsv.v
        
        styleFaderC = status.lighting.faders.c.style
        buttonMuteCStyle = status.lighting.buttons["Fader3Mute"]!.offStyle
        
        
        topFaderD = status.lighting.faders.d.colours.colourOne.toRGB().hsv
        brTopFaderD = status.lighting.faders.d.colours.colourOne.toRGB().hsv.v
        bottomFaderD = status.lighting.faders.d.colours.colourTwo.toRGB().hsv
        brBottomFaderD = status.lighting.faders.d.colours.colourTwo.toRGB().hsv.v
        
        buttonMuteDColour1 = status.lighting.buttons["Fader4Mute"]!.colours.colourOne.toRGB().hsv
        brButtonMuteDColour1 = status.lighting.buttons["Fader4Mute"]!.colours.colourOne.toRGB().hsv.v
        buttonMuteDColour2 = status.lighting.buttons["Fader4Mute"]!.colours.colourTwo.toRGB().hsv
        brButtonMuteDColour2 = status.lighting.buttons["Fader4Mute"]!.colours.colourTwo.toRGB().hsv.v
        
        styleFaderD = status.lighting.faders.d.style
        buttonMuteDStyle = status.lighting.buttons["Fader4Mute"]!.offStyle
        
        

        
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
        coughBehaviourIsHold = !status.coughButton.isToggle
        coughMuteBehaviour = status.coughButton.muteType

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
        
        gateAmount = Float((((status.micStatus.noiseGate.threshold + 59) * 100 / 59) + (status.micStatus.noiseGate.attenuation - 50)) * 100 / 150)
        gateThreshold = Float(status.micStatus.noiseGate.threshold)
        gateAttenuation = Float(status.micStatus.noiseGate.attenuation)
        gateAttack = Float(status.micStatus.noiseGate.attack.GetIntGateTime())
        gateRelease = Float(status.micStatus.noiseGate.release.GetIntGateTime())
        
        eq31Hz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer31Hz.rawValue]!)
        eq63Hz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer63Hz.rawValue]!)
        eq125Hz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer125Hz.rawValue]!)
        eq250Hz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer250Hz.rawValue]!)
        eq500Hz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer500Hz.rawValue]!)
        eq1KHz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer1KHz.rawValue]!)
        eq2KHz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer2KHz.rawValue]!)
        eq4KHz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer2KHz.rawValue]!)
        eq8KHz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer8KHz.rawValue]!)
        eq16KHz = Float(status.micStatus.equaliser.gain[EqFrequencies.Equalizer16KHz.rawValue]!)
        
        ft31Hz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer31Hz.rawValue]!)
        ft63Hz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer63Hz.rawValue]!)
        ft125Hz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer125Hz.rawValue]!)
        ft250Hz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer250Hz.rawValue]!)
        ft500Hz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer500Hz.rawValue]!)
        ft1KHz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer1KHz.rawValue]!)
        ft2KHz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer2KHz.rawValue]!)
        ft4KHz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer4KHz.rawValue]!)
        ft8KHz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer8KHz.rawValue]!)
        ft16KHz = Float(status.micStatus.equaliser.frequency[EqFrequencies.Equalizer16KHz.rawValue]!)
        
        miniEqBass = Float(status.micStatus.equaliserMini.gain.miniBassValue())
        miniEqMid = Float(status.micStatus.equaliserMini.gain.miniMidValue())
        miniEqTremble = Float(status.micStatus.equaliserMini.gain.miniTrembleValue())
        
        miniEq90Hz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer90Hz.rawValue]!)
        miniEq250Hz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer250Hz.rawValue]!)
        miniEq500Hz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer500Hz.rawValue]!)
        miniEq1KHz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer1KHz.rawValue]!)
        miniEq3KHz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer3KHz.rawValue]!)
        miniEq8KHz = Float(status.micStatus.equaliserMini.gain[MiniEqFrequencies.Equalizer8KHz.rawValue]!)
        
        miniFt90Hz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer90Hz.rawValue]!)
        miniFt250Hz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer250Hz.rawValue]!)
        miniFt500Hz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer500Hz.rawValue]!)
        miniFt1KHz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer1KHz.rawValue]!)
        miniFt3KHz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer3KHz.rawValue]!)
        miniFt8KHz = Float(status.micStatus.equaliserMini.frequency[MiniEqFrequencies.Equalizer8KHz.rawValue]!)
        
        compAmount = Float(((Double(status.micStatus.compressor.threshold + 40) * 100 / 40) + (Double(status.micStatus.compressor.ratio) * 100 / 14)) / 2)

        compThreshold = Float(status.micStatus.compressor.threshold)
        compAttack = Float(status.micStatus.compressor.attack.GetIntCompAtkTime())
        compRelease = Float(status.micStatus.compressor.release.GetIntCompRelTime())
        compRatio = Float(status.micStatus.compressor.ratio)
        compMakeUpGain = Float(status.micStatus.compressor.makeupGain)
    }
    
    public func updateProfiles() {
        let completestatus = selectedDevice.status()!
        status = selectedDevice.deviceStatus()!
        profilesList = completestatus.status.files.profiles
        profile = status.profileName
        selectedProfile = profile

    }
    
    public func updateRouter() {
        status = selectedDevice.deviceStatus()!
        routerMic = status.routerTable[0]
        routerChat = status.routerTable[1]
        routerMusic = status.routerTable[2]
        routerGame = status.routerTable[3]
        routerConsole = status.routerTable[4]
        routerLineIn = status.routerTable[5]
        routerSystem = status.routerTable[6]
        routerSamples = status.routerTable[7]
    }
    public func updateSlidersLightning() {
        status = selectedDevice.deviceStatus()!
        topFaderA = status.lighting.faders.a.colours.colourOne.toRGB().hsv
        brTopFaderA = status.lighting.faders.a.colours.colourOne.toRGB().hsv.v
        bottomFaderA = status.lighting.faders.a.colours.colourTwo.toRGB().hsv
        brBottomFaderA = status.lighting.faders.a.colours.colourTwo.toRGB().hsv.v
        
        buttonMuteAColour1 = status.lighting.buttons["Fader1Mute"]!.colours.colourOne.toRGB().hsv
        brButtonMuteAColour1 = status.lighting.buttons["Fader1Mute"]!.colours.colourOne.toRGB().hsv.v
        buttonMuteAColour2 = status.lighting.buttons["Fader1Mute"]!.colours.colourTwo.toRGB().hsv
        brButtonMuteAColour2 = status.lighting.buttons["Fader1Mute"]!.colours.colourTwo.toRGB().hsv.v

        styleFaderA = status.lighting.faders.a.style
        buttonMuteAStyle = status.lighting.buttons["Fader1Mute"]!.offStyle
        
        topFaderB = status.lighting.faders.b.colours.colourOne.toRGB().hsv
        brTopFaderB = status.lighting.faders.b.colours.colourOne.toRGB().hsv.v
        bottomFaderB = status.lighting.faders.b.colours.colourTwo.toRGB().hsv
        brBottomFaderB = status.lighting.faders.b.colours.colourTwo.toRGB().hsv.v
        
        buttonMuteBColour1 = status.lighting.buttons["Fader2Mute"]!.colours.colourOne.toRGB().hsv
        brButtonMuteBColour1 = status.lighting.buttons["Fader2Mute"]!.colours.colourOne.toRGB().hsv.v
        buttonMuteBColour2 = status.lighting.buttons["Fader2Mute"]!.colours.colourTwo.toRGB().hsv
        brButtonMuteBColour2 = status.lighting.buttons["Fader2Mute"]!.colours.colourTwo.toRGB().hsv.v
        
        styleFaderB = status.lighting.faders.b.style
        buttonMuteBStyle = status.lighting.buttons["Fader2Mute"]!.offStyle

        
        topFaderC = status.lighting.faders.c.colours.colourOne.toRGB().hsv
        brTopFaderC = status.lighting.faders.c.colours.colourOne.toRGB().hsv.v
        bottomFaderC = status.lighting.faders.c.colours.colourTwo.toRGB().hsv
        brBottomFaderC = status.lighting.faders.c.colours.colourTwo.toRGB().hsv.v
        
        buttonMuteCColour1 = status.lighting.buttons["Fader3Mute"]!.colours.colourOne.toRGB().hsv
        brButtonMuteCColour1 = status.lighting.buttons["Fader3Mute"]!.colours.colourOne.toRGB().hsv.v
        buttonMuteCColour2 = status.lighting.buttons["Fader3Mute"]!.colours.colourTwo.toRGB().hsv
        brButtonMuteCColour2 = status.lighting.buttons["Fader3Mute"]!.colours.colourTwo.toRGB().hsv.v
        
        styleFaderC = status.lighting.faders.c.style
        buttonMuteCStyle = status.lighting.buttons["Fader3Mute"]!.offStyle
        
        
        topFaderD = status.lighting.faders.d.colours.colourOne.toRGB().hsv
        brTopFaderD = status.lighting.faders.d.colours.colourOne.toRGB().hsv.v
        bottomFaderD = status.lighting.faders.d.colours.colourTwo.toRGB().hsv
        brBottomFaderD = status.lighting.faders.d.colours.colourTwo.toRGB().hsv.v
        
        buttonMuteDColour1 = status.lighting.buttons["Fader4Mute"]!.colours.colourOne.toRGB().hsv
        brButtonMuteDColour1 = status.lighting.buttons["Fader4Mute"]!.colours.colourOne.toRGB().hsv.v
        buttonMuteDColour2 = status.lighting.buttons["Fader4Mute"]!.colours.colourTwo.toRGB().hsv
        brButtonMuteDColour2 = status.lighting.buttons["Fader4Mute"]!.colours.colourTwo.toRGB().hsv.v
        
        styleFaderD = status.lighting.faders.d.style
        buttonMuteDStyle = status.lighting.buttons["Fader4Mute"]!.offStyle
    }
    
    @Published var deviceSelect: String = "Select a goxlr" {
        willSet {
            selectedDevice = GoXlr(serial: newValue)
        }
    }
    
    @Published var selectedProfile: String?
    
    @Published var profilesList: [String]
    @Published var profile: String
    
    @Published var selectedMicProfile: String?
    
    @Published var micProfilesList: [String]
    @Published var micProfile: String
    
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
    
    @Published var coughBehaviourIsHold: Bool
    @Published var coughMuteBehaviour: MuteFunction

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
    
    @Published var gateAmount: Float
    
    @Published var gateThreshold: Float
    @Published var gateAttenuation: Float
    @Published var gateAttack: Float
    @Published var gateRelease: Float
    
    //--------------------------------[Equalizer - MIC]-----------------------------------------------//
    
    @Published var eqBass: Float
    @Published var eqMid: Float
    @Published var eqTremble: Float
    
    @Published var eq31Hz: Float
    @Published var eq63Hz: Float
    @Published var eq125Hz: Float
    @Published var eq250Hz: Float
    @Published var eq500Hz: Float
    @Published var eq1KHz: Float
    @Published var eq2KHz: Float
    @Published var eq4KHz: Float
    @Published var eq8KHz: Float
    @Published var eq16KHz: Float
    
    @Published var ft31Hz: Float
    @Published var ft63Hz: Float
    @Published var ft125Hz: Float
    @Published var ft250Hz: Float
    @Published var ft500Hz: Float
    @Published var ft1KHz: Float
    @Published var ft2KHz: Float
    @Published var ft4KHz: Float
    @Published var ft8KHz: Float
    @Published var ft16KHz: Float
    
    //--------------------------------[Equalizer MINI - MIC]-----------------------------------------------//

    @Published var miniEqBass: Float
    @Published var miniEqMid: Float
    @Published var miniEqTremble: Float
    
    @Published var miniEq90Hz: Float
    @Published var miniEq250Hz: Float
    @Published var miniEq500Hz: Float
    @Published var miniEq1KHz: Float
    @Published var miniEq3KHz: Float
    @Published var miniEq8KHz: Float
    
    @Published var miniFt90Hz: Float
    @Published var miniFt250Hz: Float
    @Published var miniFt500Hz: Float
    @Published var miniFt1KHz: Float
    @Published var miniFt3KHz: Float
    @Published var miniFt8KHz: Float
    
//--------------------------------[Compressor - MIC]-----------------------------------------------//

    @Published var compAmount: Float
    @Published var compThreshold: Float
    @Published var compRatio: Float
    @Published var compAttack: Float
    @Published var compRelease: Float
    @Published var compMakeUpGain: Float

//--------------------------------[Router table - ROUTING]-----------------------------------------------//
    @Published var routerMic: [Bool]
    @Published var routerChat: [Bool]
    @Published var routerMusic: [Bool]
    @Published var routerGame: [Bool]
    @Published var routerConsole: [Bool]
    @Published var routerLineIn: [Bool]
    @Published var routerSystem: [Bool]
    @Published var routerSamples: [Bool]
    
    //--------------------------------[Mixer Colors - LIGHTNING]-----------------------------------------------//
    
    
    
    @Published var topFaderA: HSV
    @Published var brTopFaderA: CGFloat
    @Published var bottomFaderA: HSV
    @Published var brBottomFaderA: CGFloat
    
    @Published var buttonMuteAColour1: HSV
    @Published var brButtonMuteAColour1: CGFloat
    @Published var buttonMuteAColour2: HSV
    @Published var brButtonMuteAColour2: CGFloat
    
    
    @Published var styleFaderA: FaderDisplayStyle
    @Published var buttonMuteAStyle: ButtonColourOffStyle
    
    
    @Published var topFaderB: HSV
    @Published var brTopFaderB: CGFloat
    @Published var bottomFaderB: HSV
    @Published var brBottomFaderB: CGFloat
    
    @Published var buttonMuteBColour1: HSV
    @Published var brButtonMuteBColour1: CGFloat
    @Published var buttonMuteBColour2: HSV
    @Published var brButtonMuteBColour2: CGFloat
    
    @Published var styleFaderB: FaderDisplayStyle
    @Published var buttonMuteBStyle: ButtonColourOffStyle

    
    @Published var topFaderC: HSV
    @Published var brTopFaderC: CGFloat
    @Published var bottomFaderC: HSV
    @Published var brBottomFaderC: CGFloat
    
    @Published var buttonMuteCColour1: HSV
    @Published var brButtonMuteCColour1: CGFloat
    @Published var buttonMuteCColour2: HSV
    @Published var brButtonMuteCColour2: CGFloat
    
    @Published var styleFaderC: FaderDisplayStyle
    @Published var buttonMuteCStyle: ButtonColourOffStyle


    @Published var topFaderD: HSV
    @Published var brTopFaderD: CGFloat
    @Published var bottomFaderD: HSV
    @Published var brBottomFaderD: CGFloat
    
    @Published var buttonMuteDColour1: HSV
    @Published var brButtonMuteDColour1: CGFloat
    @Published var buttonMuteDColour2: HSV
    @Published var brButtonMuteDColour2: CGFloat
    
    @Published var styleFaderD: FaderDisplayStyle
    @Published var buttonMuteDStyle: ButtonColourOffStyle

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
