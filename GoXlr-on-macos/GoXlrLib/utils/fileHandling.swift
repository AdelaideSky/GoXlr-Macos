//
//  fileHandling.swift
//  GoXlr-on-macos
//
//  Created by Adélaïde Sky on 06/10/2022.
//

import Foundation
import SwiftUI

public enum profilesubfolders: String {
    case profiles
    case micprofiles = "mic-profiles"
    case presets
}
public func copyprofile(url: URL, path: profilesubfolders) {
    let folderName = "org.GoXLR-on-Linux.GoXLR-Utility/\(path.rawValue)/"
    let fileManager = FileManager.default
    if let tDocumentDirectory = fileManager.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
        let filePath =  tDocumentDirectory.appendingPathComponent("\(folderName)")
        if !fileManager.fileExists(atPath: filePath.path) {
            do {
                try fileManager.createDirectory(atPath: filePath.path, withIntermediateDirectories: true, attributes: nil)
                try fileManager.copyItem(at: url, to: filePath.appendingPathComponent("\(url.lastPathComponent)"))
            } catch {print("Couldn't create document directory or can't copy file")}
        }
        do {
            try fileManager.copyItem(at: url, to: filePath.appendingPathComponent("\(url.lastPathComponent)"))
        } catch (let error) {
            print("error on copying file")
        }
    }
}
