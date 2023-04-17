// This file was generated from JSON Schema using quicktype, do not modify it directly.
//
// Status structs.
import Foundation

public var valueUpdatedByUI = true

// MARK: - Status
/**
 Base Status struct. Only used to decode daemon's JSON. Doesn't contain any useful information.
 */
public struct Status: Codable {
    public var id: Int
    public var data: DataClass
}

// MARK: - DataClass
/**
 Enclosing struct of the status.
 */
public struct DataClass: Codable {
    public var status: StatusClass

    enum CodingKeys: String, CodingKey {
        case status = "Status"
    }
}

// MARK: - StatusClass
/**
 Status struct. Root of the Daemon Status.
 */
public struct StatusClass: Codable {
    public var config: Config
    public var mixers: [String:Mixer]
    public var paths: Paths
    public var files: Files
}

// MARK: - Config
public struct Config: Codable {
    public var daemonVersion: String
    public var autostartEnabled: Bool

    enum CodingKeys: String, CodingKey {
        case daemonVersion = "daemon_version"
        case autostartEnabled = "autostart_enabled"
    }
}

// MARK: - Files
public struct Files: Codable {
    public var profiles, micProfiles, presets: [String]
    public var samples: [String: String]
    public var icons: [String]

    enum CodingKeys: String, CodingKey {
        case profiles
        case micProfiles = "mic_profiles"
        case presets, samples, icons
    }
}

// MARK: - Mixer
public struct Mixer: Codable {
    public var hardware: Hardware
    public var faderStatus: FadersStatus
    public var micStatus: MicStatus
    public var levels: Levels
    public var router: Router
    public var coughButton: CoughButton
    public var lighting: Lighting
    public var effects: Effects?
    public var sampler: Sampler?
    public var settings: Settings
    public var button_down: ButtonDown
    public var profileName, micProfileName: String

    enum CodingKeys: String, CodingKey {
        case hardware
        case faderStatus = "fader_status"
        case micStatus = "mic_status"
        case levels, router
        case coughButton = "cough_button"
        case lighting, effects, sampler, settings
        case button_down = "button_down"
        case profileName = "profile_name"
        case micProfileName = "mic_profile_name"
    }
}

public struct ButtonDown: Codable {
    public var Fader1Mute, Fader2Mute, Fader3Mute, Fader4Mute: Bool
    public var Bleep, Cough: Bool

    // The rest are GoXLR Full Buttons. On the mini, they will simply be ignored.
    public var EffectSelect1, EffectSelect2, EffectSelect3, EffectSelect4, EffectSelect5, EffectSelect6: Bool

    // FX Button labelled as 'fxClear' in config?
    public var EffectFx, EffectMegaphone, EffectRobot, EffectHardTune: Bool

    public var SamplerSelectA, SamplerSelectB, SamplerSelectC: Bool?

    public var SamplerTopLeft, SamplerTopRight, SamplerBottomLeft, SamplerBottomRight, SamplerClear: Bool
}

// MARK: - CoughButton
public struct CoughButton: Codable {
    public var isToggle: Bool
    public var muteType, state: String

    enum CodingKeys: String, CodingKey {
        case isToggle = "is_toggle"
        case muteType = "mute_type"
        case state
    }
}

// MARK: - Effects
public struct Effects: Codable {
    public var isEnabled: Bool
    public var activePreset: String
    public var presetNames: PresetNames
    public var current: CurrentEffectPreset

    enum CodingKeys: String, CodingKey {
        case isEnabled = "is_enabled"
        case activePreset = "active_preset"
        case presetNames = "preset_names"
        case current
    }
}

// MARK: - Current
public struct CurrentEffectPreset: Codable {
    public var reverb: Reverb
    public var echo: EchoClass
    public var pitch: Pitch
    public var gender: Gender
    public var megaphone: Megaphone
    public var robot: Robot
    public var hardTune: HardTune

    enum CodingKeys: String, CodingKey {
        case reverb, echo, pitch, gender, megaphone, robot
        case hardTune = "hard_tune"
    }
}

// MARK: - EchoClass
public struct EchoClass: Codable {
    public var style: EchoStyle
    public var amount, feedback, tempo, delayLeft: Int
    public var delayRight, feedbackLeft, feedbackRight, feedbackXfbLToR: Int
    public var feedbackXfbRToL: Int

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
public struct Gender: Codable {
    public var style: GenderStyle
    public var amount: Int
}

// MARK: - HardTune
public struct HardTune: Codable {
    public var isEnabled: Bool
    public var style: HardTuneStyle
    public var amount, rate, window: Int
    public var source: String

    enum CodingKeys: String, CodingKey {
        case isEnabled = "is_enabled"
        case style, amount, rate, window, source
    }
}

// MARK: - Megaphone
public struct Megaphone: Codable {
    public var isEnabled: Bool
    public var style: MegaphoneStyle
    public var amount, postGain: Int

    enum CodingKeys: String, CodingKey {
        case isEnabled = "is_enabled"
        case style, amount
        case postGain = "post_gain"
    }
}

// MARK: - Pitch
public struct Pitch: Codable {
    public var style: PitchStyle
    public var amount, character: Int
}

// MARK: - Reverb
public struct Reverb: Codable {
    public var style: ReverbStyle
    public var amount, decay, earlyLevel, tailLevel: Int
    public var preDelay, loColour, hiColour, hiFactor: Int
    public var diffuse, modSpeed, modDepth: Int

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
public struct Robot: Codable {
    public var isEnabled: Bool { didSet { GoXlr.shared.command(.SetRobotEnabled(self.isEnabled)) } }
    public var style: RobotStyle { didSet { GoXlr.shared.command(.SetRobotStyle(self.style)) } }
    
    public var lowGain: Int { didSet { GoXlr.shared.command(.SetRobotGain(.Low, self.lowGain)) } }
    public var lowFreq: Int { didSet { GoXlr.shared.command(.SetRobotFreq(.Low, self.lowFreq)) } }
    public var lowWidth: Int { didSet { GoXlr.shared.command(.SetRobotWidth(.Low, self.lowWidth)) } }
    
    public var midGain: Int { didSet { GoXlr.shared.command(.SetRobotGain(.Medium, self.midGain)) } }
    public var midFreq: Int { didSet { GoXlr.shared.command(.SetRobotFreq(.Low, self.midFreq)) } }
    public var midWidth: Int { didSet { GoXlr.shared.command(.SetRobotWidth(.Low, self.midWidth)) } }
    
    public var highGain: Int { didSet { GoXlr.shared.command(.SetRobotGain(.High, self.highGain)) } }
    public var highFreq: Int { didSet { GoXlr.shared.command(.SetRobotFreq(.Low, self.highFreq)) } }
    public var highWidth: Int { didSet { GoXlr.shared.command(.SetRobotWidth(.Low, self.highWidth)) } }
    
    public var waveform: Int { didSet { GoXlr.shared.command(.SetRobotWaveform(self.waveform)) } }
    public var pulseWidth: Int { didSet { GoXlr.shared.command(.SetRobotPulseWidth(self.pulseWidth)) } }
    public var threshold: Int { didSet { GoXlr.shared.command(.SetRobotThreshold(self.threshold)) } }
    public var dryMix: Int { didSet { GoXlr.shared.command(.SetRobotDryMix(self.dryMix)) } }

    enum CodingKeys: String, CodingKey {
        case isEnabled = "is_enabled"
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

// MARK: - PresetNames
// WARNING: - Renaming presets only renames ACTIVE preset. Make sure to update names ONLY when the preset is active
public struct PresetNames: Codable {
    public var preset1: String { didSet { GoXlr.shared.command(.RenameActivePreset(self.preset1)) } }
    public var preset2: String { didSet { GoXlr.shared.command(.RenameActivePreset(self.preset2)) } }
    public var preset3: String { didSet { GoXlr.shared.command(.RenameActivePreset(self.preset3)) } }
    public var preset4: String { didSet { GoXlr.shared.command(.RenameActivePreset(self.preset4)) } }
    public var preset5: String { didSet { GoXlr.shared.command(.RenameActivePreset(self.preset5)) } }
    public var preset6: String { didSet { GoXlr.shared.command(.RenameActivePreset(self.preset6)) } }

    enum CodingKeys: String, CodingKey {
        case preset5 = "Preset5"
        case preset2 = "Preset2"
        case preset1 = "Preset1"
        case preset3 = "Preset3"
        case preset4 = "Preset4"
        case preset6 = "Preset6"
    }
}

// MARK: - FaderStatus
public struct FadersStatus: Codable {
    public var a: FaderStatusA
    public var b: FaderStatusB
    public var c: FaderStatusC
    public var d: FaderStatusD

    enum CodingKeys: String, CodingKey {
        case a = "A"
        case b = "B"
        case c = "C"
        case d = "D"
    }
}

// MARK: - FaderStatus
public struct FaderStatusA: Codable {
    public var channel: ChannelName { didSet { GoXlr.shared.command(.SetFader(.A, self.channel)) } }
    public var muteType: MuteFunction { didSet { GoXlr.shared.command(.SetFaderMuteFunction(.A, self.muteType)) } }
    public var scribble: ScribbleA?
    public var muteState: MuteState { didSet { GoXlr.shared.command(.SetFaderMuteState(.A, self.muteState)) } }

    enum CodingKeys: String, CodingKey {
        case channel
        case muteType = "mute_type"
        case scribble
        case muteState = "mute_state"
    }
}
public struct FaderStatusB: Codable {
    public var channel: ChannelName { didSet { GoXlr.shared.command(.SetFader(.B, self.channel)) } }
    public var muteType: MuteFunction { didSet { GoXlr.shared.command(.SetFaderMuteFunction(.B, self.muteType)) } }
    public var scribble: ScribbleB?
    public var muteState: MuteState { didSet { GoXlr.shared.command(.SetFaderMuteState(.B, self.muteState)) } }

    enum CodingKeys: String, CodingKey {
        case channel
        case muteType = "mute_type"
        case scribble
        case muteState = "mute_state"
    }
}
public struct FaderStatusC: Codable {
    public var channel: ChannelName { didSet { GoXlr.shared.command(.SetFader(.C, self.channel)) } }
    public var muteType: MuteFunction { didSet { GoXlr.shared.command(.SetFaderMuteFunction(.C, self.muteType)) } }
    public var scribble: ScribbleC?
    public var muteState: MuteState { didSet { GoXlr.shared.command(.SetFaderMuteState(.C, self.muteState)) } }

    enum CodingKeys: String, CodingKey {
        case channel
        case muteType = "mute_type"
        case scribble
        case muteState = "mute_state"
    }
}
public struct FaderStatusD: Codable {
    public var channel: ChannelName { didSet { GoXlr.shared.command(.SetFader(.D, self.channel)) } }
    public var muteType: MuteFunction { didSet { GoXlr.shared.command(.SetFaderMuteFunction(.D, self.muteType)) } }
    public var scribble: ScribbleD?
    public var muteState: MuteState { didSet { GoXlr.shared.command(.SetFaderMuteState(.D, self.muteState)) } }

    enum CodingKeys: String, CodingKey {
        case channel
        case muteType = "mute_type"
        case scribble
        case muteState = "mute_state"
    }
}

// MARK: - Scribble
public struct ScribbleA: Codable {
    public var fileName: String { didSet { GoXlr.shared.command(.SetScribbleIcon(.A, self.fileName)) } }
    public var bottomText: String { didSet { GoXlr.shared.command(.SetScribbleText(.A, self.bottomText)) } }
    public var leftText: String? { didSet { if self.leftText != nil { GoXlr.shared.command(.SetScribbleNumber(.A, self.leftText!)) } } }
    public var inverted: Bool { didSet { GoXlr.shared.command(.SetScribbleInvert(.A, self.inverted)) } }

    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case bottomText = "bottom_text"
        case leftText = "left_text"
        case inverted
    }
}
public struct ScribbleB: Codable {
    public var fileName: String { didSet { GoXlr.shared.command(.SetScribbleIcon(.B, self.fileName)) } }
    public var bottomText: String { didSet { GoXlr.shared.command(.SetScribbleText(.B, self.bottomText)) } }
    public var leftText: String? { didSet { if self.leftText != nil { GoXlr.shared.command(.SetScribbleNumber(.B, self.leftText!)) } } }
    public var inverted: Bool { didSet { GoXlr.shared.command(.SetScribbleInvert(.B, self.inverted)) } }

    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case bottomText = "bottom_text"
        case leftText = "left_text"
        case inverted
    }
}
public struct ScribbleC: Codable {
    public var fileName: String { didSet { GoXlr.shared.command(.SetScribbleIcon(.C, self.fileName)) } }
    public var bottomText: String { didSet { GoXlr.shared.command(.SetScribbleText(.C, self.bottomText)) } }
    public var leftText: String? { didSet { if self.leftText != nil { GoXlr.shared.command(.SetScribbleNumber(.C, self.leftText!)) } } }
    public var inverted: Bool { didSet { GoXlr.shared.command(.SetScribbleInvert(.C, self.inverted)) } }

    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case bottomText = "bottom_text"
        case leftText = "left_text"
        case inverted
    }
}
public struct ScribbleD: Codable {
    public var fileName: String { didSet { GoXlr.shared.command(.SetScribbleIcon(.D, self.fileName)) } }
    public var bottomText: String { didSet { GoXlr.shared.command(.SetScribbleText(.D, self.bottomText)) } }
    public var leftText: String? { didSet { if self.leftText != nil { GoXlr.shared.command(.SetScribbleNumber(.D, self.leftText!)) } } }
    public var inverted: Bool { didSet { GoXlr.shared.command(.SetScribbleInvert(.D, self.inverted)) } }

    enum CodingKeys: String, CodingKey {
        case fileName = "file_name"
        case bottomText = "bottom_text"
        case leftText = "left_text"
        case inverted
    }
}

// MARK: - Hardware
public struct Hardware: Codable {
    public var versions: Versions
    public var serialNumber, manufacturedDate: String
    public var deviceType: GoXlrModel
    public var usbDevice: USBDevice

    enum CodingKeys: String, CodingKey {
        case versions = "versions"
        case serialNumber = "serial_number"
        case manufacturedDate = "manufactured_date"
        case deviceType = "device_type"
        case usbDevice = "usb_device"
    }
}

// MARK: - USBDevice
public struct USBDevice: Codable {
    public var manufacturerName, productName: String
    public var version: [Int]
    public var busNumber, address: Int
    public var identifier: JSONNull?

    enum CodingKeys: String, CodingKey {
        case manufacturerName = "manufacturer_name"
        case productName = "product_name"
        case version
        case busNumber = "bus_number"
        case address, identifier
    }
}

// MARK: - Versions
public struct Versions: Codable {
    public var firmware: [Int]
    public var fpgaCount: Int
    public var dice: [Int]

    enum CodingKeys: String, CodingKey {
        case firmware
        case fpgaCount = "fpga_count"
        case dice
    }
}

// MARK: - Levels
public struct Levels: Codable {
    public var volumes: Volumes
    public var bleep: Int { didSet { GoXlr.shared.command(.SetSwearButtonVolume(self.bleep)) } }
    public var deess: Int { didSet { GoXlr.shared.command(.SetDeeser(self.deess)) } }
}

// MARK: - Volumes
public struct Volumes: Codable {
    public var system: Float { didSet { GoXlr.shared.command(.SetVolume(.System, Int(self.system))) } }
    public var mic: Float { didSet { GoXlr.shared.command(.SetVolume(.Mic, Int(self.mic))) } }
    public var lineIn: Float { didSet { GoXlr.shared.command(.SetVolume(.LineIn, Int(self.lineIn))) } }
    public var console: Float { didSet { GoXlr.shared.command(.SetVolume(.Console, Int(self.console))) } }
    public var game: Float { didSet { GoXlr.shared.command(.SetVolume(.Game, Int(self.game))) } }
    public var chat: Float { didSet { GoXlr.shared.command(.SetVolume(.Chat, Int(self.chat))) } }
    public var sample: Float { didSet { GoXlr.shared.command(.SetVolume(.Sample, Int(self.sample))) } }
    public var music: Float { didSet { GoXlr.shared.command(.SetVolume(.Music, Int(self.music))) } }
    public var headphones: Float { didSet { GoXlr.shared.command(.SetVolume(.Headphones, Int(self.headphones))) } }
    public var micMonitor: Float { didSet { GoXlr.shared.command(.SetVolume(.MicMonitor, Int(self.micMonitor))) } }
    public var lineOut: Float { didSet { GoXlr.shared.command(.SetVolume(.LineOut, Int(self.lineOut))) } }

    enum CodingKeys: String, CodingKey {
        case mic = "Mic"
        case lineIn = "LineIn"
        case console = "Console"
        case system = "System"
        case game = "Game"
        case chat = "Chat"
        case sample = "Sample"
        case music = "Music"
        case headphones = "Headphones"
        case micMonitor = "MicMonitor"
        case lineOut = "LineOut"
    }
}

// MARK: - Lighting
public struct Lighting: Codable {
    public var faders: Faders
    public var buttons: [String: ButtonStyle]
    public var simple: Simple
    public var sampler: LightingSampler
    public var encoders: Encoders
}

// MARK: - Button
public struct ButtonStyle: Codable {
    public var offStyle: ButtonColourOffStyle
    public var colours: Colours

    enum CodingKeys: String, CodingKey {
        case offStyle = "off_style"
        case colours
    }
}

// MARK: - Colours
public struct Colours: Codable {
    public var colourOne: String
    public var colourTwo: String

    enum CodingKeys: String, CodingKey {
        case colourOne = "colour_one"
        case colourTwo = "colour_two"
    }
}

// MARK: - Encoders
public struct Encoders: Codable {
    public var reverb, echo, pitch, gender: GenderClass?

    enum CodingKeys: String, CodingKey {
        case reverb = "Reverb"
        case echo = "Echo"
        case pitch = "Pitch"
        case gender = "Gender"
    }
}

// MARK: - GenderClass
public struct GenderClass: Codable {
    public var colourOne: String
    public var colourTwo: String
    public var colourThree: String

    enum CodingKeys: String, CodingKey {
        case colourOne = "colour_one"
        case colourTwo = "colour_two"
        case colourThree = "colour_three"
    }
}

// MARK: - Faders
public struct Faders: Codable {
    public var c, b, a, d: Fader

    enum CodingKeys: String, CodingKey {
        case c = "C"
        case b = "B"
        case a = "A"
        case d = "D"
    }
}

// MARK: - FadersA
public struct Fader: Codable {
    public var style: String
    public var colours: Colours
}

// MARK: - LightingSampler
public struct LightingSampler: Codable {
    public var samplerSelectA, samplerSelectB, samplerSelectC: SamplerSelect?

    enum CodingKeys: String, CodingKey {
        case samplerSelectA = "SamplerSelectA"
        case samplerSelectB = "SamplerSelectB"
        case samplerSelectC = "SamplerSelectC"
    }
}

// MARK: - SamplerSelect
public struct SamplerSelect: Codable {
    public var offStyle: ButtonColourOffStyle
    public var colours: GenderClass

    enum CodingKeys: String, CodingKey {
        case offStyle = "off_style"
        case colours
    }
}

// MARK: - Simple
public struct Simple: Codable {
    public var scribble3, scribble4, scribble1, scribble2: Accent?
    public var global, accent: Accent

    enum CodingKeys: String, CodingKey {
        case scribble3 = "Scribble3"
        case global = "Global"
        case scribble1 = "Scribble1"
        case scribble2 = "Scribble2"
        case scribble4 = "Scribble4"
        case accent = "Accent"
    }
}

// MARK: - Accent
public struct Accent: Codable {
    public var colourOne: String

    enum CodingKeys: String, CodingKey {
        case colourOne = "colour_one"
    }
}

// MARK: - MicStatus
public struct MicStatus: Codable {
    public var micType: String
    public var micGains: MicGains
    public var equaliser: Equaliser
    public var equaliserMini: EqualiserMini
    public var noiseGate: NoiseGate
    public var compressor: Compressor

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
public struct Compressor: Codable {
    public var threshold, ratio, attack, release: Int
    public var makeupGain: Int

    enum CodingKeys: String, CodingKey {
        case threshold, ratio, attack, release
        case makeupGain = "makeup_gain"
    }
}

// MARK: - Equaliser
public struct Equaliser: Codable {
    public var gain, frequency: [String: Double]
}

// MARK: - EqualiserMini
public struct EqualiserMini: Codable {
    public var gain, frequency: Frequency
}

// MARK: - Frequency
public struct Frequency: Codable {
    public var equalizer250Hz, equalizer1KHz, equalizer500Hz, equalizer8KHz: Int
    public var equalizer90Hz, equalizer3KHz: Int

    enum CodingKeys: String, CodingKey {
        case equalizer250Hz = "Equalizer250Hz"
        case equalizer1KHz = "Equalizer1KHz"
        case equalizer500Hz = "Equalizer500Hz"
        case equalizer8KHz = "Equalizer8KHz"
        case equalizer90Hz = "Equalizer90Hz"
        case equalizer3KHz = "Equalizer3KHz"
    }
}

// MARK: - MicGains
public struct MicGains: Codable {
    public var micGainsDynamic, condenser, jack: Int

    enum CodingKeys: String, CodingKey {
        case micGainsDynamic = "Dynamic"
        case condenser = "Condenser"
        case jack = "Jack"
    }
}

// MARK: - NoiseGate
public struct NoiseGate: Codable {
    public var threshold, attack, release: Int
    public var enabled: Bool
    public var attenuation: Int
}

// MARK: - Router
public struct Router: Codable {
    public var microphone, chat, music, game: Chat
    public var console, lineIn, system, samples: Chat

    enum CodingKeys: String, CodingKey {
        case microphone = "Microphone"
        case chat = "Chat"
        case music = "Music"
        case game = "Game"
        case console = "Console"
        case lineIn = "LineIn"
        case system = "System"
        case samples = "Samples"
    }
}

// MARK: - Chat
public struct Chat: Codable {
    public var headphones, broadcastMix, lineOut, chatMic: Bool
    public var sampler: Bool

    enum CodingKeys: String, CodingKey {
        case headphones = "Headphones"
        case broadcastMix = "BroadcastMix"
        case lineOut = "LineOut"
        case chatMic = "ChatMic"
        case sampler = "Sampler"
    }
}

// MARK: - S210401735CQKSampler
public struct Sampler: Codable {
    public var banks: Banks
}

// MARK: - Banks
public struct Banks: Codable {
    public var C, A, B: Bank

    enum CodingKeys: String, CodingKey {
        case C = "C"
        case A = "A"
        case B = "B"
    }
}

// MARK: - BanksA
public struct Bank: Codable {
    public var BottomLeft, TopLeft, TopRight, BottomRight: SamplerButton

    enum CodingKeys: String, CodingKey {
        case BottomLeft = "BottomLeft"
        case TopLeft = "TopLeft"
        case TopRight = "TopRight"
        case BottomRight = "BottomRight"
    }
}

// MARK: - BottomLeft
public struct SamplerButton: Codable {
    public var function: Function
    public var order: Order
    public var samples: [JSONAny]
    public var is_playing: Bool

    enum CodingKeys: String, CodingKey {
        case function, order, samples
        case is_playing = "is_playing"
    }
}

public enum Function: String, Codable {
    case playNext = "PlayNext"
}

public enum Order: String, Codable {
    case sequential = "Sequential"
}

// MARK: - Settings
public struct Settings: Codable {
    public var display: Display
    public var muteHoldDuration: Int
    public var vcMuteAlsoMuteCM: Bool

    enum CodingKeys: String, CodingKey {
        case display
        case muteHoldDuration = "mute_hold_duration"
        case vcMuteAlsoMuteCM = "vc_mute_also_mute_cm"
    }
}

// MARK: - Display
public struct Display: Codable {
    public var gate, compressor, equaliser, equaliserFine: String

    enum CodingKeys: String, CodingKey {
        case gate, compressor, equaliser
        case equaliserFine = "equaliser_fine"
    }
}

// MARK: - Paths
public struct Paths: Codable {
    public var profileDirectory, micProfileDirectory, samplesDirectory, presetsDirectory: String
    public var iconsDirectory: String

    enum CodingKeys: String, CodingKey {
        case profileDirectory = "profile_directory"
        case micProfileDirectory = "mic_profile_directory"
        case samplesDirectory = "samples_directory"
        case presetsDirectory = "presets_directory"
        case iconsDirectory = "icons_directory"
    }
}

// MARK: - Encode/decode helpers

public class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public var hashValue: Int {
        return 0
    }

    public func hash(into hasher: inout Hasher) {
        // No-op
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}

class JSONCodingKey: CodingKey {
    public let key: String

    required init?(intValue: Int) {
        return nil
    }

    required init?(stringValue: String) {
        key = stringValue
    }

    public var intValue: Int? {
        return nil
    }

    public var stringValue: String {
        return key
    }
}

public class JSONAny: Codable {

    public let value: Any

    static func decodingError(forCodingPath codingPath: [CodingKey]) -> DecodingError {
        let context = DecodingError.Context(codingPath: codingPath, debugDescription: "Cannot decode JSONAny")
        return DecodingError.typeMismatch(JSONAny.self, context)
    }

    static func encodingError(forValue value: Any, codingPath: [CodingKey]) -> EncodingError {
        let context = EncodingError.Context(codingPath: codingPath, debugDescription: "Cannot encode JSONAny")
        return EncodingError.invalidValue(value, context)
    }

    static func decode(from container: SingleValueDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if container.decodeNil() {
            return JSONNull()
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout UnkeyedDecodingContainer) throws -> Any {
        if let value = try? container.decode(Bool.self) {
            return value
        }
        if let value = try? container.decode(Int64.self) {
            return value
        }
        if let value = try? container.decode(Double.self) {
            return value
        }
        if let value = try? container.decode(String.self) {
            return value
        }
        if let value = try? container.decodeNil() {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer() {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decode(from container: inout KeyedDecodingContainer<JSONCodingKey>, forKey key: JSONCodingKey) throws -> Any {
        if let value = try? container.decode(Bool.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Int64.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(Double.self, forKey: key) {
            return value
        }
        if let value = try? container.decode(String.self, forKey: key) {
            return value
        }
        if let value = try? container.decodeNil(forKey: key) {
            if value {
                return JSONNull()
            }
        }
        if var container = try? container.nestedUnkeyedContainer(forKey: key) {
            return try decodeArray(from: &container)
        }
        if var container = try? container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key) {
            return try decodeDictionary(from: &container)
        }
        throw decodingError(forCodingPath: container.codingPath)
    }

    static func decodeArray(from container: inout UnkeyedDecodingContainer) throws -> [Any] {
        var arr: [Any] = []
        while !container.isAtEnd {
            let value = try decode(from: &container)
            arr.append(value)
        }
        return arr
    }

    static func decodeDictionary(from container: inout KeyedDecodingContainer<JSONCodingKey>) throws -> [String: Any] {
        var dict = [String: Any]()
        for key in container.allKeys {
            let value = try decode(from: &container, forKey: key)
            dict[key.stringValue] = value
        }
        return dict
    }

    static func encode(to container: inout UnkeyedEncodingContainer, array: [Any]) throws {
        for value in array {
            if let value = value as? Bool {
                try container.encode(value)
            } else if let value = value as? Int64 {
                try container.encode(value)
            } else if let value = value as? Double {
                try container.encode(value)
            } else if let value = value as? String {
                try container.encode(value)
            } else if value is JSONNull {
                try container.encodeNil()
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer()
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout KeyedEncodingContainer<JSONCodingKey>, dictionary: [String: Any]) throws {
        for (key, value) in dictionary {
            let key = JSONCodingKey(stringValue: key)!
            if let value = value as? Bool {
                try container.encode(value, forKey: key)
            } else if let value = value as? Int64 {
                try container.encode(value, forKey: key)
            } else if let value = value as? Double {
                try container.encode(value, forKey: key)
            } else if let value = value as? String {
                try container.encode(value, forKey: key)
            } else if value is JSONNull {
                try container.encodeNil(forKey: key)
            } else if let value = value as? [Any] {
                var container = container.nestedUnkeyedContainer(forKey: key)
                try encode(to: &container, array: value)
            } else if let value = value as? [String: Any] {
                var container = container.nestedContainer(keyedBy: JSONCodingKey.self, forKey: key)
                try encode(to: &container, dictionary: value)
            } else {
                throw encodingError(forValue: value, codingPath: container.codingPath)
            }
        }
    }

    static func encode(to container: inout SingleValueEncodingContainer, value: Any) throws {
        if let value = value as? Bool {
            try container.encode(value)
        } else if let value = value as? Int64 {
            try container.encode(value)
        } else if let value = value as? Double {
            try container.encode(value)
        } else if let value = value as? String {
            try container.encode(value)
        } else if value is JSONNull {
            try container.encodeNil()
        } else {
            throw encodingError(forValue: value, codingPath: container.codingPath)
        }
    }

    public required init(from decoder: Decoder) throws {
        if var arrayContainer = try? decoder.unkeyedContainer() {
            self.value = try JSONAny.decodeArray(from: &arrayContainer)
        } else if var container = try? decoder.container(keyedBy: JSONCodingKey.self) {
            self.value = try JSONAny.decodeDictionary(from: &container)
        } else {
            let container = try decoder.singleValueContainer()
            self.value = try JSONAny.decode(from: container)
        }
    }

    public func encode(to encoder: Encoder) throws {
        if let arr = self.value as? [Any] {
            var container = encoder.unkeyedContainer()
            try JSONAny.encode(to: &container, array: arr)
        } else if let dict = self.value as? [String: Any] {
            var container = encoder.container(keyedBy: JSONCodingKey.self)
            try JSONAny.encode(to: &container, dictionary: dict)
        } else {
            var container = encoder.singleValueContainer()
            try JSONAny.encode(to: &container, value: self.value)
        }
    }
}
