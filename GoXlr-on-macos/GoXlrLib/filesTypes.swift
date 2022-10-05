//
//  filesTypes.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 30/09/2022.
//

import Foundation
import SwiftUI
import UniformTypeIdentifiers

extension UTType {
    static var goxlrProfile: UTType {
        UTType(exportedAs: "com.adecorp.GoXlr-Profile")
    }
    static var goxlrMicProfile: UTType {
        UTType(exportedAs: "com.adecorp.GoXlr-Mic-Profile")
    }
    static var goxlrFXPreset: UTType {
        UTType(exportedAs: "com.adecorp.GoXlr-FX-Preset")
    }
}
class profileDocument : NSDocument {

    @objc func readFromURL(url: NSURL, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        Swift.print("zoerjeoig")
        self.fileURL = url as URL
        self.fileType = typeName
        return true
    }
    @objc func readFromData(data: Data, ofType typeName: String, error outError: NSErrorPointer) -> Bool {
        Swift.print("zoerjeoig")
        self.fileType = typeName
        return true
    }

    convenience init(contentsOf: URL, ofType: String) throws {
        Swift.print("zoerjeoig")
        self.init()

        switch ofType {
            case "internal":
            self.fileURL = contentsOf
            self.fileType = ofType
            break

        default:
            Swift.print("nyi")
        }
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
   }

    override func read(from url: URL, ofType typeName: String) throws {
        Swift.print("zoerjeoig")
        switch typeName {
        case "internal":
            self.fileURL = url
            self.fileType = typeName
            break
            
        case "h2o":
            let data = try Data.init(contentsOf: url)
            do {
                try! self.read(from: data, ofType: typeName)
                self.fileURL = url as URL
                self.fileType = typeName
            }
            break
            
        default:
            Swift.print("nyi \(typeName)")
            break
        }
        throw NSError(domain: NSOSStatusErrorDomain, code: unimpErr, userInfo: nil)
        
    }

    override func write(to url: URL, ofType typeName: String) throws {
        
    }
}

struct micProfileDocument: FileDocument {

    init() {}

    static var readableContentTypes: [UTType] { [.goxlrMicProfile] }

    init(configuration: ReadConfiguration) throws {}
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data()
        return .init(regularFileWithContents: data)
    }
}

struct fxPresetDocument: FileDocument {

    init() {}

    static var readableContentTypes: [UTType] { [.goxlrFXPreset] }

    init(configuration: ReadConfiguration) throws {}
    
    func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
        let data = Data()
        return .init(regularFileWithContents: data)
    }
}


