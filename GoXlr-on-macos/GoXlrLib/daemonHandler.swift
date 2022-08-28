//
//  daemonHandler.swift
//  GoXlr App
//
//  Created by Adélaïde Sky on 01/08/2022.
//

import Foundation
var daemonProcess = Process()
public class Daemon {
    
    public func start(args: [daemonArguments.RawValue]?) -> Bool {
        let daemonPath = Bundle.main.url(forResource: "goxlr-daemon", withExtension: "")
        daemonProcess.executableURL = daemonPath!
        if args != nil {
            daemonProcess.arguments = args
        }
        let outputPipe = Pipe()
        let errorPipe = Pipe()

        daemonProcess.standardOutput = outputPipe
        daemonProcess.standardError = errorPipe
        
        try? daemonProcess.run()
        sleep(1)
        return true
    }
    public func stop() {
        daemonProcess.interrupt()
    }
    public func restart(args: [daemonArguments.RawValue]?) -> Bool {
        daemonProcess.interrupt()
        daemonProcess = Process()
        
        return self.start(args: args)
    }
}

public enum daemonArguments: String, CaseIterable, Codable {
    case noHttp = "--http-disable"
    case enableCors = "--http-enable-cors"
    case httpPort = "--http-port"
    case logLevel = "--log-level"
}
public enum logLevels: String, CaseIterable, Codable {
    case off
    case error
    case warn
    case info
    case debug
    case trace
}
