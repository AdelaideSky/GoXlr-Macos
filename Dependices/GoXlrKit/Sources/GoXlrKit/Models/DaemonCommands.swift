//
//  File.swift
//  
//
//  Created by Adélaïde Sky on 20/01/2023.
//

import Foundation
import SwiftUI

/**
 GoXlr command type, with corresponding parameters.
 */
public enum GoXLRCommand: Codable {
    case SetFader(FaderName, ChannelName)
    case SetFaderMuteFunction(FaderName, MuteFunction)

    case SetVolume(ChannelName, Int)
    case SetMicrophoneType(MicrophoneType)
    case SetMicrophoneGain(MicrophoneType, Int)
    case SetRouter(InputDevice, OutputDevice, Bool)

    // Cough Button
    case SetCoughMuteFunction(MuteFunction)
    case SetCoughIsHold(Bool)

    // Bleep Button
    case SetSwearButtonVolume(Int)

    // EQ Settings
    case SetEqMiniGain(MiniEqFrequencies, Int)
    case SetEqMiniFreq(MiniEqFrequencies, Float)
    case SetEqGain(EqFrequencies, Int)
    case SetEqFreq(EqFrequencies, Float)

    // Gate Settings
    case SetGateThreshold(Int)
    case SetGateAttenuation(Int)
    case SetGateAttack(GateTimes)
    case SetGateRelease(GateTimes)
    case SetGateActive(Bool)

    // Compressor..
    case SetCompressorThreshold(Int)
    case SetCompressorRatio(CompressorRatio)
    case SetCompressorAttack(CompressorAttackTime)
    case SetCompressorReleaseTime(CompressorReleaseTime)
    case SetCompressorMakeupGain(Int)

    // Used to switch between display modes..
    case SetElementDisplayMode(DisplayModeComponents, DisplayMode)

    // DeEss
    case SetDeeser(Int)

    // Colour Related Settings..
    case SetFaderDisplayStyle(FaderName, FaderDisplayStyle)
    case SetFaderColours(FaderName, String, String)
    case SetAllFaderColours(String, String)
    case SetAllFaderDisplayStyle(FaderDisplayStyle)

    case SetButtonColours(GoXlrButton, String, String?)
    case SetButtonOffStyle(GoXlrButton, ButtonColourOffStyle)
    case SetButtonGroupColours(ButtonColourGroups, String, String?)
    case SetButtonGroupOffStyle(ButtonColourGroups, ButtonColourOffStyle)

    case SetSimpleColour(SimpleColourTargets, String)
    case SetEncoderColour(EncoderColourTargets, String, String, String)
    case SetSampleColour(SamplerColourTargets, String, String, String)
    case SetSampleOffStyle(SamplerColourTargets, ButtonColourOffStyle)

    // Effect Related Settings..
    case LoadEffectPreset(String)
    case RenameActivePreset(String)
    case SaveActivePreset

    // Reverb
    case SetReverbStyle(ReverbStyle)
    case SetReverbAmount(Int)
    case SetReverbDecay(Int)
    case SetReverbEarlyLevel(Int)
    case SetReverbTailLevel(Int)
    case SetReverbPreDelay(Int)
    case SetReverbLowColour(Int)
    case SetReverbHighColour(Int)
    case SetReverbHighFactor(Int)
    case SetReverbDiffuse(Int)
    case SetReverbModSpeed(Int)
    case SetReverbModDepth(Int)

    // Echo..
    case SetEchoStyle(EchoStyle)
    case SetEchoAmount(Int)
    case SetEchoFeedback(Int)
    case SetEchoTempo(Int)
    case SetEchoDelayLeft(Int)
    case SetEchoDelayRight(Int)
    case SetEchoFeedbackLeft(Int)
    case SetEchoFeedbackRight(Int)
    case SetEchoFeedbackXFBLtoR(Int)
    case SetEchoFeedbackXFBRtoL(Int)

    // Pitch
    case SetPitchStyle(PitchStyle)
    case SetPitchAmount(Int)
    case SetPitchCharacter(Int)

    // Gender
    case SetGenderStyle(GenderStyle)
    case SetGenderAmount(Int)

    // Megaphone
    case SetMegaphoneStyle(MegaphoneStyle)
    case SetMegaphoneAmount(Int)
    case SetMegaphonePostGain(Int)

    // Robot
    case SetRobotStyle(RobotStyle)
    case SetRobotGain(RobotRange, Int)
    case SetRobotFreq(RobotRange, Int)
    case SetRobotWidth(RobotRange, Int)
    case SetRobotWaveform(Int)
    case SetRobotPulseWidth(Int)
    case SetRobotThreshold(Int)
    case SetRobotDryMix(Int)

    // Hardtune
    case SetHardTuneStyle(HardTuneStyle)
    case SetHardTuneAmount(Int)
    case SetHardTuneRate(Int)
    case SetHardTuneWindow(Int)
    case SetHardTuneSource(HardTuneSource)

    // Sampler..
    case SetSamplerFunction(SampleBank, SampleButtons, SamplePlaybackMode)
    case SetSamplerOrder(SampleBank, SampleButtons, SamplePlayOrder)
    case AddSample(SampleBank, SampleButtons, String)
    case SetSampleStartPercent(SampleBank, SampleButtons, Int, Float)
    case SetSampleStopPercent(SampleBank, SampleButtons, Int, Float)
    case RemoveSampleByIndex(SampleBank, SampleButtons, Int)
    case PlaySampleByIndex(SampleBank, SampleButtons, Int)
    case PlayNextSample(SampleBank, SampleButtons)
    case StopSamplePlayback(SampleBank, SampleButtons)

    // Scribbles
    case SetScribbleIcon(FaderName, String)
    case SetScribbleText(FaderName, String)
    case SetScribbleNumber(FaderName, String)
    case SetScribbleInvert(FaderName, Bool)

    // Profile Handling..
    case NewProfile(String)
    case LoadProfile(String)
    case LoadProfileColours(String)
    case SaveProfile
    case SaveProfileAs(String)
    case DeleteProfile(String)

    case NewMicProfile(String)
    case LoadMicProfile(String)
    case SaveMicProfile
    case SaveMicProfileAs(String)
    case DeleteMicProfile(String)

    // General Settings
    case SetMuteHoldDuration(Int)
    case SetVCMuteAlsoMuteCM(Bool)

    // These control the current GoXLR 'State'..
    case SetActiveEffectPreset(EffectBankPresets)
    case SetActiveSamplerBank(SampleBank)
    case SetMegaphoneEnabled(Bool)
    case SetRobotEnabled(Bool)
    case SetHardTuneEnabled(Bool)
    case SetFXEnabled(Bool)
    case SetFaderMuteState(FaderName, MuteState)
    case SetCoughMuteState(MuteState)
}


