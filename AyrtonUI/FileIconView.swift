//
//  FileIconView.swift
//  AyrtonUI
//
//  Created by Michael Bergamo on 1/16/25.
//

import SwiftUI
import UniformTypeIdentifiers

struct FileIconView: View {
    let path: String

    @State private var icon: Image?
    @State private var isLoading = true

    var body: some View {
        Group {
            if isLoading {
                ProgressView()
            } else if let icon = icon {
                icon.resizable().frame(width: 24, height: 24)
            } else {
                Image(systemName: "questionmark.circle") // Default icon
                    .resizable().frame(width: 24, height: 24)
            }
        }
        .task {
            await loadIcon()
        }
    }

    private func loadIcon() async {
        let fileManager = FileManager.default

        var isDirectory: ObjCBool = false
        let fileExists = fileManager.fileExists(atPath: path, isDirectory: &isDirectory)

        if !fileExists {
            await MainActor.run { isLoading = false }
            return
        }

        if isDirectory.boolValue {
            await MainActor.run {
                icon = Image(systemName: "folder")
                isLoading = false
            }
            return
        }

        let fileExtension = URL(fileURLWithPath: path).pathExtension

        if let uti = UTType(filenameExtension: fileExtension) {
            if let systemImageName = systemImageName(for: uti) {
                await MainActor.run {
                    icon = Image(systemName: systemImageName)
                    isLoading = false
                }
                return
            }
        }

        let task = Process()
        task.executableURL = URL(fileURLWithPath: "/usr/bin/file")
        task.arguments = ["-b", "--mime-type", path]

        let pipe = Pipe()
        task.standardOutput = pipe

        do {
            try task.run()
            task.waitUntilExit()

            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            if let output = String(data: data, encoding: .utf8)?.trimmingCharacters(in: .whitespacesAndNewlines) {
                if let systemImageName = systemImageName(forMimeType: output) {
                    await MainActor.run {
                        icon = Image(systemName: systemImageName)
                        isLoading = false
                    }
                    return
                }
            }
        } catch {
            print("Error running file command: \(error)")
        }

        await MainActor.run { isLoading = false }
    }

    private func systemImageName(for uti: UTType) -> String? {
        if uti.conforms(to: .image) { return "photo" }
        if uti.conforms(to: .movie) { return "film" }
        if uti.conforms(to: .pdf) { return "doc.richtext" }
        if uti.conforms(to: .text) { return "doc.text" }
        if uti.conforms(to: .application) { return "app" }
        if uti.conforms(to: .folder) { return "folder" }
        return nil
    }
    
    private func systemImageName(forMimeType mimeType: String) -> String? {
        if mimeType.hasPrefix("image/") { return "photo" }
        if mimeType.hasPrefix("video/") || mimeType.hasPrefix("application/x-mpegURL") || mimeType.hasPrefix("video/mp4") { return "film" }
        if mimeType.hasPrefix("application/pdf") { return "doc.richtext" }
        if mimeType.hasPrefix("text/") { return "doc.text" }
        if mimeType.hasPrefix("application/zip") || mimeType.hasPrefix("application/x-gzip") || mimeType.hasPrefix("application/x-tar") { return "archivebox" }
        if mimeType.contains("executable") { return "hammer" }
        if mimeType.contains("Mach-O") { return "cpu" }
        return nil
    }
}
