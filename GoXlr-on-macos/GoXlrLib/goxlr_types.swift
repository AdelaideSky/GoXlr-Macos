//
//  goxlr_types.swift
//  testgoxlrlib
//
//  Created by Adélaïde Sky on 23/06/2022.
//

import Foundation

public enum Model: String {
    case Mini
    case Full
}

public enum ChannelName: String, Equatable, CaseIterable, Codable {
    case Mic
    case LineIn
    case Console
    case System
    case Game
    case Chat
    case Sample
    case Music
    case Headphones
    case MicMonitor
    case LineOut
    
    
}


public enum FaderName: String {
    case A
    case B
    case C
    case D
}

enum EncoderName: Int {
    case Pitch = 0x00
    case Gender = 0x01
    case Reverb = 0x02
    case Echo = 0x03
}

public enum InputDevice: String {
    case Microphone
    case Chat
    case Music
    case Game
    case Console
    case LineIn
    case System
    case Samples
}

public enum OutputDevice: String {
    case Headphones
    case BroadcastMix
    case LineOut
    case ChatMic
    case Sampler
}

enum EffectKey: Int {
    case DisableMic = 0x0158,
    BleepLevel = 0x0073,
    GateMode = 0x0010,
    GateThreshold = 0x0011,
    GateEnabled = 0x0014,
    GateAttenuation = 0x0015,
    GateAttack = 0x0016,
    GateRelease = 0x0017,
    Unknown14b = 0x014b,
    Equalizer31HzFrequency = 0x0126,
    Equalizer31HzGain = 0x0127,
    Equalizer63HzFrequency = 0x00f8,
    Equalizer63HzGain = 0x00f9,
    Equalizer125HzFrequency = 0x0113,
    Equalizer125HzGain = 0x0114,
    Equalizer250HzFrequency = 0x0129,
    Equalizer250HzGain = 0x012a,
    Equalizer500HzFrequency = 0x0116,
    Equalizer500HzGain = 0x0117,
    Equalizer1KHzFrequency = 0x011d,
    Equalizer1KHzGain = 0x011e,
    Equalizer2KHzFrequency = 0x012c,
    Equalizer2KHzGain = 0x012d,
    Equalizer4KHzFrequency = 0x0120,
    Equalizer4KHzGain = 0x0121,
    Equalizer8KHzFrequency = 0x0109,
    Equalizer8KHzGain = 0x010a,
    Equalizer16KHzFrequency = 0x012f,
    Equalizer16KHzGain = 0x0130,
    CompressorThreshold = 0x013d,
    CompressorRatio = 0x013c,
    CompressorAttack = 0x013e,
    CompressorRelease = 0x013f,
    CompressorMakeUpGain = 0x0140,
    DeEsser = 0x000b,
    ReverbAmount = 0x0076,
    ReverbDecay = 0x002f,
    ReverbEarlyLevel = 0x0037,
    ReverbTailLevel = 0x0039,   // Always sent as 0.
    ReverbPredelay = 0x0030,
    ReverbLoColor = 0x0032,
    ReverbHiColor = 0x0033,
    ReverbHiFactor = 0x0034,
    ReverbDiffuse = 0x0031,
    ReverbModSpeed = 0x0035,
    ReverbModDepth = 0x0036,
    ReverbStyle = 0x002e,
    EchoAmount = 0x0075,
    EchoFeedback = 0x0028,
    EchoTempo = 0x001f,
    EchoDelayL = 0x0022,
    EchoDelayR = 0x0023,
    EchoFeedbackL = 0x0024,
    EchoFeedbackR = 0x0025,
    EchoXFBLtoR = 0x0026,
    EchoXFBRtoL = 0x0027,
    EchoSource = 0x001e,
    EchoDivL = 0x0020,
    EchoDivR = 0x0021,
    EchoFilterStyle = 0x002a,
    PitchAmount = 0x005d,
    PitchCharacter = 0x0167,
    PitchThreshold = 0x0159,
    GenderAmount = 0x0060,
    MegaphoneAmount = 0x003c,
    MegaphonePostGain = 0x0040,
    MegaphoneStyle = 0x003a,
    MegaphoneHP = 0x003d,
    MegaphoneLP = 0x003e,
    MegaphonePreGain = 0x003f,
    MegaphoneDistType = 0x0041,
    MegaphonePresenceGain = 0x0042,
    MegaphonePresenceFC = 0x0043,
    MegaphonePresenceBW = 0x0044,
    MegaphoneBeatboxEnable = 0x0045,
    MegaphoneFilterControl = 0x0046,
    MegaphoneFilter = 0x0047,
    MegaphoneDrivePotGainCompMid = 0x0048,
    MegaphoneDrivePotGainCompMax = 0x0049,
    RobotLowGain = 0x0134,
    RobotLowFreq = 0x0133,
    RobotLowWidth = 0x0135,
    RobotMidGain = 0x013a,
    RobotMidFreq = 0x0139,
    RobotMidWidth = 0x013b,
    RobotHiGain = 0x0137,
    RobotHiFreq = 0x0136,
    RobotHiWidth = 0x0138,
    RobotWaveform = 0x0147,
    RobotPulseWidth = 0x0146,
    RobotThreshold = 0x0157,
    RobotDryMix = 0x014d,
    RobotStyle = 0x0000,
    HardTuneKeySource = 0x0059, // Always sent as 0.
    HardTuneAmount = 0x005a,
    HardTuneRate = 0x005c,
    HardTuneWindow = 0x005b,
    HardTuneScale = 0x005e,
    HardTunePitchAmount = 0x005f,

    RobotEnabled = 0x014e,
    MegaphoneEnabled = 0x00d7,
    HardTuneEnabled = 0x00d8,

    Encoder1Enabled = 0x00d5,
    Encoder2Enabled = 0x00d6,
    Encoder3Enabled = 0x0150,
    Encoder4Enabled = 0x0151
}

// Eq and Derivative allow for these to be added to a HashSet (the values make EnumSet unusable)
enum MicrophoneParamKey: Int {
    case MicType = 0x000,
    DynamicGain = 0x001,
    CondenserGain = 0x002,
    JackGain = 0x003,
    GateThreshold = 0x30200,
    GateAttack = 0x30400,
    GateRelease = 0x30600,
    GateAttenuation = 0x30900,
    CompressorThreshold = 0x60200,
    CompressorRatio = 0x60300,
    CompressorAttack = 0x60400,
    CompressorRelease = 0x60600,
    CompressorMakeUpGain = 0x60700,
    BleepLevel = 0x70100,

    /*
      These are the values for the GoXLR mini, it seems there's a difference in how the two
      are setup, The Mini does EQ via mic parameters, where as the full does it via effects.
     */
    Equalizer90HzFrequency = 0x40000,
    Equalizer90HzGain = 0x40001,
    Equalizer250HzFrequency = 0x40003,
    Equalizer250HzGain = 0x40004,
    Equalizer500HzFrequency = 0x40006,
    Equalizer500HzGain = 0x40007,
    Equalizer1KHzFrequency = 0x50000,
    Equalizer1KHzGain = 0x50001,
    Equalizer3KHzFrequency = 0x50003,
    Equalizer3KHzGain = 0x50004,
    Equalizer8KHzFrequency = 0x50006,
    Equalizer8KHzGain = 0x50007
}


public enum FaderDisplayStyle: String {
    case TwoColour
    case Gradient
    case Meter
    case GradientMeter
}

public enum ButtonColourTargets: String {
    // These are all the buttons from the GoXLR Mini.
    case Fader1Mute
    case Fader2Mute
    case Fader3Mute
    case Fader4Mute
    case Bleep
    case Cough

    // The rest are GoXLR Full Buttons. On the mini, they will simply be ignored.
    case EffectSelect1
    case EffectSelect2
    case EffectSelect3
    case EffectSelect4
    case EffectSelect5
    case EffectSelect6

    // FX Button labelled as 'fxClear' in config?
    case EffectFx
    case EffectMegaphone
    case EffectRobot
    case EffectHardTune

    case SamplerSelectA
    case SamplerSelectB
    case SamplerSelectC

    case SamplerTopLeft
    case SamplerTopRight
    case SamplerBottomLeft
    case SamplerBottomRight
    case SamplerClear
}

public enum ButtonColourGroups: String {
    case FaderMute
    case EffectSelector
    case SampleBankSelector
    case SamplerButtons
}

public enum ButtonColourOffStyle: String {
    case Dimmed
    case Colour2
    case DimmedColour2
}

// MuteChat

public enum MuteFunction: String, Equatable, CaseIterable, Codable {
    case All
    case ToStream
    case ToVoiceChat
    case ToPhones
    case ToLineOut
}


public enum MicrophoneType: String {
    case Dynamic
    case Condenser
    case Jack
}



public enum MiniEqFrequencies: String {
    case Equalizer90Hz
    case Equalizer250Hz
    case Equalizer500Hz
    case Equalizer1KHz
    case Equalizer3KHz
    case Equalizer8KHz
}


public enum EqFrequencies: String {
    case Equalizer31Hz
    case Equalizer63Hz
    case Equalizer125Hz
    case Equalizer250Hz
    case Equalizer500Hz
    case Equalizer1KHz
    case Equalizer2KHz
    case Equalizer4KHz
    case Equalizer8KHz
    case Equalizer16KHz
}

public enum CompressorRatio: String {
    case Ratio1_0, Ratio1_1, Ratio1_2, Ratio1_4,  Ratio1_6,  Ratio1_8, Ratio2_0, Ratio2_5, Ratio3_2,
    Ratio4_0, Ratio5_6, Ratio8_0, Ratio16_0, Ratio32_0, Ratio64_0
}

public enum GateTimes: String {
    case Gate10ms,   Gate20ms,   Gate30ms,   Gate40ms,   Gate50ms,   Gate60ms,   Gate70ms,   Gate80ms,
    Gate90ms,   Gate100ms,  Gate110ms,  Gate120ms,  Gate130ms,  Gate140ms,  Gate150ms,  Gate160ms,
    Gate170ms,  Gate180ms,  Gate190ms,  Gate200ms,  Gate250ms,  Gate300ms,  Gate350ms,  Gate400ms,
    Gate450ms,  Gate500ms,  Gate550ms,  Gate600ms,  Gate650ms,  Gate700ms,  Gate750ms,  Gate800ms,
    Gate850ms,  Gate900ms,  Gate950ms,  Gate1000ms, Gate1100ms, Gate1200ms, Gate1300ms, Gate1400ms,
    Gate1500ms, Gate1600ms, Gate1700ms, Gate1800ms, Gate1900ms, Gate2000ms
}

public enum CompressorAttackTime: String {
    // Note: 0ms is technically 0.001ms
    case Comp0ms,  Comp2ms,  Comp3ms,  Comp4ms,  Comp5ms,  Comp6ms,  Comp7ms,  Comp8ms,  Comp9ms,
    Comp10ms, Comp12ms, Comp14ms, Comp16ms, Comp18ms, Comp20ms, Comp23ms, Comp26ms, Comp30ms,
    Comp35ms, Comp40ms
}

public enum CompressorReleaseTime: String {
    // Note: 0 is technically 15 :)
    case Comp0ms,    Comp15ms,   Comp25ms,   Comp35ms,  Comp45ms,  Comp55ms,  Comp65ms,  Comp75ms,
    Comp85ms,   Comp100ms,  Comp115ms,  Comp140ms,  Comp170ms, Comp230ms, Comp340ms, Comp680ms,
    Comp1000ms, Comp1500ms, Comp2000ms, Comp3000ms
}
