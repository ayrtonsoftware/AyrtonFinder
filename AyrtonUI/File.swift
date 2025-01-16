//
//  File.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//

import SwiftUI
import UniformTypeIdentifiers

public class File: Identifiable, Equatable {
    public let id = UUID()
    public var url: URL
    public init() {
        url = URL(fileURLWithPath: "/")
    }
    public init(url: URL) {
        self.url = url
    }
    var isFolder: Bool {
        return false
    }
    
    static func isHiddenFile(atPath path: String) -> Bool {
        let fileManager = FileManager.default

        do {
            let attributes = try fileManager.attributesOfItem(atPath: path)

            if let fileType = attributes[.type] as? FileAttributeType, fileType == .typeDirectory {
                return URL(fileURLWithPath: path).lastPathComponent.starts(with: ".")
            } else {
                let url = URL(fileURLWithPath: path)
                let resourceValues = try url.resourceValues(forKeys: [.isHiddenKey])
                return resourceValues.isHidden ?? false
            }
        } catch {
            print("Error getting file attributes: \(error)")
            return false
        }
    }
    
    static func iconForPath(path: String) -> Image {
        let fileManager = FileManager.default

        // Check if the path is a directory
        var isDirectory: ObjCBool = false
        if fileManager.fileExists(atPath: path, isDirectory: &isDirectory) {
            if isDirectory.boolValue {
                return Image(systemName: "folder")
            }
        }
        
        // Check if the file exists
        guard fileManager.fileExists(atPath: path) else {
            print("File does not exist at path: \(path)")
            return Image(systemName: "doc")
        }

        // Get the file extension
        let fileExtension = URL(fileURLWithPath: path).pathExtension

        // First check common types based on extension
        if let uti = UTType(filenameExtension: fileExtension) {
            if uti.conforms(to: .image) { return Image(systemName: "photo") }
            if uti.conforms(to: .movie) { return Image(systemName: "film") }
            if uti.conforms(to: .pdf) { return Image(systemName: "doc.richtext") }
            if uti.conforms(to: .text) { return Image(systemName: "doc.text") }
            if uti.conforms(to: .application) { return Image(systemName: "app") }
        }

        // Use `file` command for more accurate type detection
        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/file") // Path to the `file` command
        task.arguments = ["-b", "--mime-type", path] // -b for brief output, --mime-type for mime type

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
            task.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                
                if output.hasPrefix("image/") { return Image(systemName: "photo") }
                if output.hasPrefix("video/") || output.hasPrefix("application/x-mpegURL") || output.hasPrefix("video/mp4") { return Image(systemName: "film") }
                if output.hasPrefix("application/pdf") { return Image(systemName: "doc.richtext") }
                if output.hasPrefix("text/") { return Image(systemName: "doc.text") }
                if output.hasPrefix("application/zip") || output.hasPrefix("application/x-gzip") { return Image(systemName: "archivebox") }
                if output.contains("executable") { return Image(systemName: "hammer") } // Check if it's executable
                if output.contains("Mach-O") { return Image(systemName: "cpu") }
            }
        } catch {
            print("Error running file command: \(error)")
        }

        return Image(systemName: "doc") // Default icon if all else fails
    }
    
    // Equatable conformance
    public static func == (lhs: File, rhs: File) -> Bool {
        return lhs.url == rhs.url
    }
    
    // Hashable conformance
    func hash(into hasher: inout Hasher) {
        hasher.combine(url)
    }
}
