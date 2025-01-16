//
//  Untitled.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//

import SwiftUI

public class Folder: File {
    var files: [File] = []
    override public init(url: URL) {
        super.init(url: url)
    }
    override public var isFolder: Bool {
        return true
    }
    override var icon: Image {
        return Image(systemName: "folder")
    }
    public func load() {
        let fileManager = FileManager.default
        
        do {
            let fileURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for url in fileURLs {
                var isDirectory: ObjCBool = false
                if fileManager.fileExists(atPath: url.path,
                                          isDirectory: &isDirectory) {
                    if isDirectory.boolValue {
                        files.append(Folder(url: url))
                    } else {
                        files.append(File(url: url))
                    }
                }
            }
        } catch {
            print("Error reading directory: \(error)")
            return
        }
    }
}
