////
////  FileView.swift
////  Zora2Import
////
////  Created by Michael Bergamo on 1/14/25.
////

import SwiftUI
import Combine

public struct FileView: View {
    @ObservedObject var vm: FinderVM
    @State var contentView: AnyView = AnyView(Text("NOPE"))
    
    public init(vm: FinderVM) {
        self.vm = vm
    }
    
    func runShellCommand(path: String, arguments: [String] = []) -> (output: String?, error: String?, exitCode: Int) {
        let process = Process()
        process.executableURL = URL(fileURLWithPath: path) // Use executableURL
        process.arguments = arguments
        
        let outputPipe = Pipe()
        process.standardOutput = outputPipe
        
        let errorPipe = Pipe()
        process.standardError = errorPipe
        
        do {
            try process.run()
            process.waitUntilExit()
            
            let outputData = outputPipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: outputData, encoding: .utf8)
            
            let errorData = errorPipe.fileHandleForReading.readDataToEndOfFile()
            let error = String(data: errorData, encoding: .utf8)
            
            return (output: output, error: nil, exitCode: Int(process.terminationStatus))
        } catch {
            return (output: nil, error: error.localizedDescription, exitCode: -1) // Return error on exception
        }
    }
    
    func determineFileType(_ file: File) -> String? {
        print("determining file type [\(file.url.pathExtension)]")
        if file.url.pathExtension == "plist" {
            return "PLIST"
        }
        
        let (output, error, exitCode) = runShellCommand(path: "/usr/bin/file", arguments: [file.url.path])
        print("File is \(output)")
        if let error = error {
            print("Error: \(error)")
            return nil
        }
        if let output = output {
            let tokens = output.components(separatedBy: ":")
            print(tokens)
            if tokens.count >= 2 {
                return tokens[1].trimmingCharacters(in: .whitespacesAndNewlines)
            }
        }
        return nil
    }
    
    func getContentView(file: File?) {
        guard let file = file else {
            contentView = AnyView(Text("666666"))
            return
        }
        DispatchQueue.global(qos: .userInitiated).async {
            print("FileView::getContentView")
            guard let fileType = determineFileType(file) else {
                contentView = AnyView(Text("NOPE!2"))
                return
            }
            if fileType.contains(" image data") {
                contentView = AnyView(ImageView(vm: vm))
            }
            else if fileType == "PLIST" {
                // TODO contentView = AnyView(InfoPlistView(vm: vm))
                contentView = AnyView(TextEditorView(vm: vm))
            }
            else if fileType == "ASCII text" {
                contentView = AnyView(TextEditorView(vm: vm))
            }
        }
    }
    
    public var body: some View {
        VStack {
            contentView
        }
        .border(Color.gray, width: 1)
        .onChange(of: vm.currentFile) { newValue in
            getContentView(file: vm.currentFile)
        }
    }
}
