//
//  GoLib.swift
//  GoXlr Panel
//
//  Created by Adélaïde Sky on 5/12/22.
//

extension StringProtocol {
    subscript(offset: Int) -> Character { self[index(startIndex, offsetBy: offset)] }
    subscript(range: Range<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: ClosedRange<Int>) -> SubSequence {
        let startIndex = index(self.startIndex, offsetBy: range.lowerBound)
        return self[startIndex..<index(startIndex, offsetBy: range.count)]
    }
    subscript(range: PartialRangeFrom<Int>) -> SubSequence { self[index(startIndex, offsetBy: range.lowerBound)...] }
    subscript(range: PartialRangeThrough<Int>) -> SubSequence { self[...index(startIndex, offsetBy: range.upperBound)] }
    subscript(range: PartialRangeUpTo<Int>) -> SubSequence { self[..<index(startIndex, offsetBy: range.upperBound)] }
}

import Foundation
import SwiftUI
import ShellOut
import UniformTypeIdentifiers


func ClientCommand(arg1: String, arg2: String) -> String {
    let task = Process()
    let pipe = Pipe()
    let bundle = Bundle.main
    let client = bundle.url(forResource: "goxlr-client", withExtension: nil)
    guard client != nil else {
        print("GoXlr-Client executable could not be found!")
        return("GoXlr-Client executable could not be found!")
    }
    task.executableURL = client!
    if arg1 != "" && arg2 != "" {
            task.arguments = [arg1, arg2]
    }
    if arg1 != "" && arg2 == "" {
        task.arguments = [arg1]
    }
    task.standardOutput = pipe
    task.standardError = pipe
    do {
        try task.run()
        print("Command '\(arg1)' executed successfully!")
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        return(output)
        
    } catch {
        print("Error running Command: \(error)")
    }
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return(output)
}
func ComplexClientCommand(arg1: String, arg2: String, arg3: String, arg4: String) -> String {
    let task = Process()
    let pipe = Pipe()
    let bundle = Bundle.main
    let client = bundle.url(forResource: "goxlr-client", withExtension: nil)
    guard client != nil else {
        print("GoXlr-Client executable could not be found!")
        return("GoXlr-Client executable could not be found!")
    }
    task.executableURL = client!
    if arg1 != "" && arg2 != "" && arg3 == "" && arg4 == ""{
            task.arguments = [arg1, arg2]
    }
    if arg1 != "" && arg2 != "" && arg3 != "" && arg4 != "" {
        task.arguments = [arg1, arg2, arg3, arg4]
    }
    if arg1 != "" && arg2 != "" && arg3 != "" && arg4 == "" {
        task.arguments = [arg1, arg2, arg3]
    }
    task.standardOutput = pipe
    task.standardError = pipe
    do {
        try task.run()
        print("Command '\(arg1)' executed successfully!")
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        let output = String(data: data, encoding: .utf8)!
        return(output)
        
    } catch {
        print("Error running Command: \(error)")
    }
    
    let data = pipe.fileHandleForReading.readDataToEndOfFile()
    let output = String(data: data, encoding: .utf8)!
    
    return(output)
}

func Daemon(command: String) {
    let task = Process()
    let pipe = Pipe()
    let bundle = Bundle.main
    let goxlrdaemon = bundle.url(forResource: "goxlr-daemon", withExtension: nil)
    task.executableURL = goxlrdaemon!
    task.standardOutput = pipe
    task.standardError = pipe
    if command == "start" {
        Task {
            do {
                try task.run()
                let data = pipe.fileHandleForReading.readDataToEndOfFile()
                let output = String(data: data, encoding: .utf8)!
                print(output)
                print("Daemon started successfully!")
            } catch {
                print("Error launching Daemon: \(error)")
            }
        }
    }
    else if command == "stop" {
        do {
            let output = try shellOut(to: "/usr/bin/killall", arguments: ["goxlr-daemon"])
        print(output)
        } catch {
            let error = error as! ShellOutError
            print(error.message) // Prints STDERR
            print(error.output) // Prints STDOUT
            
        }
    }
    else {
    }
}

func GetGoXlrRouting() -> Array<Bool> {
    var returnvalue: Array<Bool> = []
    do {
        let output = ClientCommand(arg1: "--status", arg2: "")
        print(output)
        let informations = output.components(separatedBy: "\n")
        if informations.count <= 2 {
                return([false])
        }
        //mic -> stream
        if String(informations[35])[19] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //mic -> chat
        if String(informations[37])[19] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //mic -> headphones
        if String(informations[34])[19] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //mic -> line out
        if String(informations[36])[19] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //mic -> sampler
        if String(informations[38])[19] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        
        //chat -> stream
        if String(informations[35])[29] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //chat -> headphones
        if String(informations[34])[29] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //chat -> line out
        if String(informations[36])[29] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //chat -> sampler
        if String(informations[38])[29] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}

        //music -> stream
        if String(informations[35])[37] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //music -> chat
        if String(informations[37])[37] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //music -> headphones
        if String(informations[34])[37] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //music -> line-out
        if String(informations[36])[37] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //music -> sampler
        if String(informations[38])[37] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}

        //game -> stream
        if String(informations[35])[44] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //game ->chat
        if String(informations[37])[44] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //game ->headphones
        if String(informations[34])[44] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //game ->line-out
        if String(informations[36])[44] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //game -> sampler
        if String(informations[38])[44] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}

        //console -> stream
        if String(informations[35])[53] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //console -> chat
        if String(informations[37])[53] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //console -> headphones
        if String(informations[34])[53] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //console ->line out
        if String(informations[36])[53] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //console -> sampler
        if String(informations[38])[53] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}

        //line-in -> stream
        if String(informations[35])[62] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //line-in -> chat
        if String(informations[37])[62] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //line-in -> headphones
        if String(informations[34])[62] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //line-in -> line-out
        if String(informations[36])[62] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //line-in -> sampler
        if String(informations[38])[62] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}

        //system -> stream
        if String(informations[35])[71] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //system -> chat
        if String(informations[37])[71] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //system -> headphones
        if String(informations[34])[71] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //system -> line-out
        if String(informations[36])[71] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //system -> sampler
        if String(informations[38])[71] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}

        //sampler -> stream
        if String(informations[35])[81] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //sampler ->chat
        if String(informations[37])[81] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //sampler -> headphones
        if String(informations[34])[81] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
        //sampler -> lineout
        if String(informations[36])[81] == "X" {returnvalue.append(true)}
        else {returnvalue.append(false)}
    }
    return(returnvalue)
}

func GetGoXlrState() -> Array<String> {
    var returnvalue = [""]
    do {
        let output = ClientCommand(arg1: "--status", arg2: "")
        print(output)
        let informations = output.components(separatedBy: "\n")
        if informations.count <= 2 {
                return(["nil"])
        }
        let type = String(String(informations[1]).suffix(5).prefix(4))
        returnvalue.append(type)
        let profile = String(informations[13])
        returnvalue.append(profile)
        
        let fadera = String(informations[14]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnvalue.append(fadera)
        let faderb = String(informations[15]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnvalue.append(faderb)
        let faderc = String(informations[16]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnvalue.append(faderc)
        let faderd = String(informations[17]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnvalue.append(faderd)
        
        let micvolume = String(String(informations[18]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(micvolume)
        let lineinvolume = String(String(informations[19]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(lineinvolume)
        let consolevolume = String(String(informations[20]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(consolevolume)
        let systemvolume = String(String(informations[21]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(systemvolume)
        let gamevolume = String(String(informations[22]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(gamevolume)
        let chatvolume = String(String(informations[23]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(chatvolume)
        let samplevolume = String(String(informations[24]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(samplevolume)
        let musicvolume = String(String(informations[25]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(musicvolume)
        let headphonesvolume = String(String(informations[26]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(headphonesvolume)
        let micmonitorvolume = String(String(informations[27]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(micmonitorvolume)
        let lineoutvolume = String(String(informations[28]).components(separatedBy: " ")[2].dropLast(1))
        returnvalue.append(lineoutvolume)
        
    }
    return(returnvalue)
}

func LoadProfile(url: String) {
    ClientCommand(arg1: "--load-profile", arg2: url)
}
func SaveProfile() {
    ClientCommand(arg1: "--save-profile", arg2: "")
}


func GoXlrConnected() -> String {
    if ClientCommand(arg1: "--status", arg2: "").contains("Error: Could not connect to the GoXLR daemon process") {
    return("no")
    }
    else if ClientCommand(arg1: "--status", arg2: "").contains("Error: Multiple GoXLR devices are connected, please specify which one to control") {
        return("no")
    }
    else {
        return("yes")
    }
}

func LaunchDaemon() {
    Daemon(command:"start")
    if ClientCommand(arg1: "--status", arg2: "").contains("Error: Could not connect to the GoXLR daemon process") {
        sleep(1)
    }
}
func ToggleRouting(chanin: String, chanout: String, state: Bool) {
    var status = ""
    if state {
        status = "true"
    }
    if state == false {
        status = "false"
    }
    print(ComplexClientCommand(arg1: "router", arg2: chanin, arg3: chanout, arg4: status))
}
func cBool(i: String) -> Bool {
    if i == "true" {return(true)}
    else if i == "false" {return(false)}
    else {return false}
}
func FirstGetRouting() -> Array<Bool> {
    LaunchDaemon()
    return(GetGoXlrRouting())
}


func RoutingListSection() -> [ListSection] {
    LaunchDaemon()
    do {
        let output = ClientCommand(arg1: "--status", arg2: "")
        print(output)
        let informations = output.components(separatedBy: "\n")
        if informations.count <= 2 {
            let nonez: [ListSection] = [
                ListSection(label: "", enabled: false),
                ListSection(label: "", enabled: false)
            ]
            
            return(nonez)
        }
        let sections: [ListSection] = [
            ListSection(label: "micstream", enabled: {if String(informations[35])[19] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "micchat", enabled: {if String(informations[37])[19] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "michead", enabled: {if String(informations[34])[19] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "micline", enabled: {if String(informations[36])[19] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "micsampl", enabled: {if String(informations[38])[19] == "X" {return(true)} else {return(false)}}()),
            
            
            ListSection(label: "chatstream", enabled: {if String(informations[35])[29] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "chathead", enabled: {if String(informations[34])[29] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "chatline", enabled: {if String(informations[36])[29] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "chatsampl", enabled: {if String(informations[38])[29] == "X" {return(true)} else {return(false)}}()),
            
            
            ListSection(label: "musicstream", enabled: {if String(informations[35])[37] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "musicchat", enabled: {if String(informations[37])[37] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "musichead", enabled: {if String(informations[34])[37] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "musicline", enabled: {if String(informations[36])[37] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "musicsampl", enabled: {if String(informations[38])[37] == "X" {return(true)} else {return(false)}}()),
            
            
            ListSection(label: "gamestream", enabled: {if String(informations[35])[44] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "gamechat", enabled: {if String(informations[37])[44] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "gamehead", enabled: {if String(informations[34])[44] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "gameline", enabled: {if String(informations[36])[44] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "gamesampl", enabled: {if String(informations[38])[44] == "X" {return(true)} else {return(false)}}()),
            
            
            ListSection(label: "consolestream", enabled: {if String(informations[35])[53] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "consolechat", enabled: {if String(informations[37])[53] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "consolehead", enabled: {if String(informations[34])[53] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "consoleline", enabled: {if String(informations[36])[53] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "consolesampl", enabled: {if String(informations[38])[53] == "X" {return(true)} else {return(false)}}()),
            
            
            ListSection(label: "lineinstream", enabled: {if String(informations[35])[62] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "lineinchat", enabled: {if String(informations[37])[62] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "lineinhead", enabled: {if String(informations[34])[62] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "lineinline", enabled: {if String(informations[36])[62] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "lineinsampl", enabled: {if String(informations[38])[62] == "X" {return(true)} else {return(false)}}()),
            
            
            ListSection(label: "systemstream", enabled: {if String(informations[35])[71] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "systemchat", enabled: {if String(informations[37])[71] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "systemhead", enabled: {if String(informations[34])[71] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "systemline", enabled: {if String(informations[36])[71] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "systemsampl", enabled: {if String(informations[38])[71] == "X" {return(true)} else {return(false)}}()),
            
            
            ListSection(label: "samplstream", enabled: {if String(informations[35])[81] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "samplchat", enabled: {if String(informations[37])[81] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "samplhead", enabled: {if String(informations[34])[81] == "X" {return(true)} else {return(false)}}()),
            ListSection(label: "samplline", enabled: {if String(informations[36])[81] == "X" {return(true)} else {return(false)}}()),
        ]
        return(sections)

        
        
    }
}
func GetFadersAssignement() -> Array<String> {
    var returnvalue = [""]
    do {
        let output = ClientCommand(arg1: "--status", arg2: "")
        print(output)
        let informations = output.components(separatedBy: "\n")
        if informations.count <= 2 {
                return(["nil"])
        }
        let fadera = String(informations[14]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnvalue.append(fadera)
        let faderb = String(informations[15]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnvalue.append(faderb)
        let faderc = String(informations[16]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnvalue.append(faderc)
        let faderd = String(informations[17]).components(separatedBy: " ")[3].dropLast(1).lowercased()
        returnvalue.append(faderd)
    }
    return(returnvalue)
}

func GetMuteBehaviours() -> Array<String> {
    var returnvalue = [""]
    do {
        let output = ClientCommand(arg1: "--status", arg2: "")
        print(output)
        let informations = output.components(separatedBy: "\n")
        if informations.count <= 2 {
                return(["nil"])
        }
        var mutefadera = String(informations[14]).components(separatedBy: " ")[6]
        if mutefadera == "All" {mutefadera = "all"} else if mutefadera == "ToStream" {mutefadera = "to-stream"} else if mutefadera == "ToVoiceChat" {mutefadera = "to-voice-chat"} else if mutefadera == "ToPhones" {mutefadera = "to-phones"} else if mutefadera == "ToLineOut" {mutefadera = "to-line-out"}
        returnvalue.append(mutefadera)
        
        var mutefaderb = String(informations[15]).components(separatedBy: " ")[6]
        if mutefaderb == "All" {mutefaderb = "all"} else if mutefaderb == "ToStream" {mutefaderb = "to-stream"} else if mutefaderb == "ToVoiceChat" {mutefaderb = "to-voice-chat"} else if mutefaderb == "ToPhones" {mutefaderb = "to-phones"} else if mutefaderb == "ToLineOut" {mutefaderb = "to-line-out"}
        returnvalue.append(mutefaderb)
        var mutefaderc = String(informations[16]).components(separatedBy: " ")[6]
        if mutefaderc == "All" {mutefaderc = "all"} else if mutefaderc == "ToStream" {mutefaderc = "to-stream"} else if mutefaderc == "ToVoiceChat" {mutefaderc = "to-voice-chat"} else if mutefaderc == "ToPhones" {mutefaderc = "to-phones"} else if mutefaderc == "ToLineOut" {mutefaderc = "to-line-out"}
        returnvalue.append(mutefaderc)
        var mutefaderd = String(informations[17]).components(separatedBy: " ")[6]
        if mutefaderd == "All" {mutefaderd = "all"} else if mutefaderd == "ToStream" {mutefaderd = "to-stream"} else if mutefaderd == "ToVoiceChat" {mutefaderd = "to-voice-chat"} else if mutefaderd == "ToPhones" {mutefaderd = "to-phones"} else if mutefaderd == "ToLineOut" {mutefaderd = "to-line-out"}
        returnvalue.append(mutefaderd)
    }
    return(returnvalue)
}
