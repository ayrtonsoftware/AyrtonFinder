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
    
    public func load(addHiddenFiles: Bool) {
        let fileManager = FileManager.default
        
        do {
            files.removeAll()
            let fileURLs = try fileManager.contentsOfDirectory(at: url, includingPropertiesForKeys: nil)
            for url in fileURLs {
                var isDirectory: ObjCBool = false
                if fileManager.fileExists(atPath: url.path,
                                          isDirectory: &isDirectory) {
                    let isHidden = File.isHiddenFile(atPath: url.path)
                    print("Is file hidden: \(url.path) --- \(isHidden)")
                    if !isHidden || (isHidden && addHiddenFiles) {
                        if isDirectory.boolValue {
                            files.append(Folder(url: url))
                        } else {
                            files.append(File(url: url))
                        }
                    }
                }
            }
        } catch {
            print("Error reading directory: \(error)")
            return
        }
    }
}
