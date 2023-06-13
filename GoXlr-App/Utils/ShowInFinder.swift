//
//  ShowInFinder.swift
//  GoXlr-App
//
//  Created by Adélaïde Sky on 22/04/2023.
//

import Foundation
import SwiftUI

extension URL {
    var isDirectory: Bool {
        return (try? resourceValues(forKeys: [.isDirectoryKey]))?.isDirectory == true
    }
    func showInFinder() {
        if self.isDirectory {
            NSWorkspace.shared.selectFile(nil, inFileViewerRootedAtPath: self.path)
        } else {
            NSWorkspace.shared.activateFileViewerSelecting([self])
        }
    }
}
