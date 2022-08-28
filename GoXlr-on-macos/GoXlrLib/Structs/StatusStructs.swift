
// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let daemonStatus = try? newJSONDecoder().decode(DaemonStatus.self, from: jsonData)

import Foundation

// MARK: - DaemonStatus
public struct daemonStatus: Codable {
    let status: Status

    enum CodingKeys: String, CodingKey {
        case status = "Status"
    }
}

// MARK: - Status
struct Status: Codable {
    let mixers: [String: Mixer]
    let paths: Paths
    let files: Files
}

// MARK: - Files
struct Files: Codable {
    let profiles, micProfiles, presets: [String]

    enum CodingKeys: String, CodingKey {
        case profiles
        case micProfiles = "mic_profiles"
        case presets
    }
}

// MARK: - Mixer
public struct Mixer: Codable {
    let hardware: Hardware
    let faderStatus: [FaderStatus]
    let micStatus: MicStatus
    let levels: Levels
    let router: [Int]
    let routerTable: [[Bool]]
    let coughButton: CoughButton
    let lighting: Lighting
    let effects: Effects?
    let profileName, micProfileName: String

    enum CodingKeys: String, CodingKey {
        case hardware
        case faderStatus = "fader_status"
        case micStatus = "mic_status"
        case levels, router
        case routerTable = "router_table"
        case coughButton = "cough_button"
        case lighting, effects
        case profileName = "profile_name"
        case micProfileName = "mic_profile_name"
    }
}


// MARK: - CoughButton
struct CoughButton: Codable {
    let isToggle: Bool
    let muteType: MuteFunction

    enum CodingKeys: String, CodingKey {
        case isToggle = "is_toggle"
        case muteType = "mute_type"
    }
}

// MARK: - Effects
struct Effects: Codable {
    let activePreset: String
    let presetNames: [String:String]
    let current: CurrentEffects

    enum CodingKeys: String, CodingKey {
        case activePreset = "active_preset"
        case presetNames = "preset_names"
        case current
    }
}

struct CurrentEffects: Codable {
    let reverb: Reverb
    let echo: Echo
    let pitch: Pitch
    let gender: Gender
    let megaphone: Megaphone
    let robot: Robot
    let hardTune: HardTune
    
    enum CodingKeys: String, CodingKey {
        case reverb, echo, pitch, gender, megaphone, robot
        case hardTune = "hard_tune"
    }
}

// MARK: - Echo
struct Echo: Codable {
    let style: EchoStyle
    let amount, feedback, tempo, delayLeft: Int
    let delayRight, feedbackLeft, feedbackRight, feedbackXfbLToR: Int
    let feedbackXfbRToL: Int

    enum CodingKeys: String, CodingKey {
        case style, amount, feedback, tempo
        case delayLeft = "delay_left"
        case delayRight = "delay_right"
        case feedbackLeft = "feedback_left"
        case feedbackRight = "feedback_right"
        case feedbackXfbLToR = "feedback_xfb_l_to_r"
        case feedbackXfbRToL = "feedback_xfb_r_to_l"
    }
}

// MARK: - Gender
struct Gender: Codable {
    let style: GenderStyle
    let amount: Int
}

// MARK: - HardTune
struct HardTune: Codable {
    let style: HardTuneStyle
    let amount, rate, window: Int
    let source: HardTuneSource
}

// MARK: - Megaphone
struct Megaphone: Codable {
    let style: MegaphoneStyle
    let amount, postGain: Int

    enum CodingKeys: String, CodingKey {
        case style, amount
        case postGain = "post_gain"
    }
}

// MARK: - Pitch
struct Pitch: Codable {
    let style: PitchStyle
    let amount, character: Int
}

// MARK: - Reverb
struct Reverb: Codable {
    let style: String
    let amount, decay, earlyLevel, tailLevel: Int
    let preDelay, loColour, hiColour, hiFactor: Int
    let diffuse, modSpeed, modDepth: Int

    enum CodingKeys: String, CodingKey {
        case style, amount, decay
        case earlyLevel = "early_level"
        case tailLevel = "tail_level"
        case preDelay = "pre_delay"
        case loColour = "lo_colour"
        case hiColour = "hi_colour"
        case hiFactor = "hi_factor"
        case diffuse
        case modSpeed = "mod_speed"
        case modDepth = "mod_depth"
    }
}

// MARK: - Robot
struct Robot: Codable {
    let style: RobotStyle
    let lowGain, lowFreq, lowWidth, midGain: Int
    let midFreq, midWidth, highGain, highFreq: Int
    let highWidth, waveform, pulseWidth, threshold: Int
    let dryMix: Int

    enum CodingKeys: String, CodingKey {
        case style
        case lowGain = "low_gain"
        case lowFreq = "low_freq"
        case lowWidth = "low_width"
        case midGain = "mid_gain"
        case midFreq = "mid_freq"
        case midWidth = "mid_width"
        case highGain = "high_gain"
        case highFreq = "high_freq"
        case highWidth = "high_width"
        case waveform
        case pulseWidth = "pulse_width"
        case threshold
        case dryMix = "dry_mix"
    }
}


// MARK: - FaderStatus
struct FaderStatus: Codable {
    let channel: ChannelName
    let muteType: MuteFunction

    enum CodingKeys: String, CodingKey {
        case channel
        case muteType = "mute_type"
    }
}

// MARK: - Hardware
struct Hardware: Codable {
    let versions: Versions
    let serialNumber, manufacturedDate, deviceType: String
    let usbDevice: USBDevice

    enum CodingKeys: String, CodingKey {
        case versions
        case serialNumber = "serial_number"
        case manufacturedDate = "manufactured_date"
        case deviceType = "device_type"
        case usbDevice = "usb_device"
    }
}

// MARK: - USBDevice
struct USBDevice: Codable {
    let manufacturerName, productName: String
    let version: [Int]
    let isClaimed, hasKernelDriverAttached: Bool
    let busNumber, address: Int

    enum CodingKeys: String, CodingKey {
        case manufacturerName = "manufacturer_name"
        case productName = "product_name"
        case version
        case isClaimed = "is_claimed"
        case hasKernelDriverAttached = "has_kernel_driver_attached"
        case busNumber = "bus_number"
        case address
    }
}

// MARK: - Versions
struct Versions: Codable {
    let firmware: [Int]
    let fpgaCount: Int
    let dice: [Int]

    enum CodingKeys: String, CodingKey {
        case firmware
        case fpgaCount = "fpga_count"
        case dice
    }
}

// MARK: - Levels
struct Levels: Codable {
    let volumes: [Int]
    let bleep, deess: Int
}

// MARK: - Lighting
struct Lighting: Codable {
    let faders: Faders
    let buttons: [String: daemonButton]
    
}


struct daemonButton: Codable {
    let offStyle: ButtonColourOffStyle
    let colours: daemonColours

    enum CodingKeys: String, CodingKey {
        case offStyle = "off_style"
        case colours
    }
}

// MARK: - Colours
struct daemonColours: Codable {
    let colourOne, colourTwo: String

    enum CodingKeys: String, CodingKey {
        case colourOne = "colour_one"
        case colourTwo = "colour_two"
    }
}



// MARK: - Faders
struct Faders: Codable {
    let b, c, d, a: A

    enum CodingKeys: String, CodingKey {
        case b = "B"
        case c = "C"
        case d = "D"
        case a = "A"
    }
}

// MARK: - A
struct A: Codable {
    let style: FaderDisplayStyle
    let colours: daemonColours
}

// MARK: - MicStatus
struct MicStatus: Codable {
    let micType: MicrophoneType
    let micGains: [Int]
    let equaliser: Equaliser
    let equaliserMini: EqualiserMini
    let noiseGate: NoiseGate
    let compressor: Compressor

    enum CodingKeys: String, CodingKey {
        case micType = "mic_type"
        case micGains = "mic_gains"
        case equaliser
        case equaliserMini = "equaliser_mini"
        case noiseGate = "noise_gate"
        case compressor
    }
}

// MARK: - Compressor
struct Compressor: Codable {
    let threshold, ratio, attack, release: Int
    let makeupGain: Int

    enum CodingKeys: String, CodingKey {
        case threshold, ratio, attack, release
        case makeupGain = "makeup_gain"
    }
}

// MARK: - Equaliser
struct Equaliser: Codable {
    let gain, frequency: [String: Double]
}

// MARK: - EqualiserMini
struct EqualiserMini: Codable {
    let gain, frequency: [String: Double]
}

// MARK: - Frequency
struct Frequency: Codable {
    let equalizer500Hz, equalizer90Hz, equalizer8KHz, equalizer1KHz: Int
    let equalizer250Hz, equalizer3KHz: Int

    enum CodingKeys: String, CodingKey {
        case equalizer500Hz = "Equalizer500Hz"
        case equalizer90Hz = "Equalizer90Hz"
        case equalizer8KHz = "Equalizer8KHz"
        case equalizer1KHz = "Equalizer1KHz"
        case equalizer250Hz = "Equalizer250Hz"
        case equalizer3KHz = "Equalizer3KHz"
    }
}

// MARK: - NoiseGate
struct NoiseGate: Codable {
    let threshold, attack, release: Int
    let enabled: Bool
    let attenuation: Int
}

// MARK: - Paths
struct Paths: Codable {
    let profileDirectory, micProfileDirectory, samplesDirectory, presetsDirectory: String

    enum CodingKeys: String, CodingKey {
        case profileDirectory = "profile_directory"
        case micProfileDirectory = "mic_profile_directory"
        case samplesDirectory = "samples_directory"
        case presetsDirectory = "presets_directory"
    }
}
