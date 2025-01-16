//
//  TextEditorView.swift
//  Zora2Import
//
//  Created by Michael Bergamo on 1/14/25.
//
//

import SwiftUI

struct TextEditorView: View {
    @State var text: String = "Loading..." // Initial loading message
    @ObservedObject var vm: FinderVM

    enum FileLoadingError: Error {
        case fileNotFound
        case invalidEncoding
        case readFailed
    }
    
    func loadTextFile(atPath path: String) {
        DispatchQueue.global(qos: .userInitiated).async {
            guard FileManager.default.fileExists(atPath: path) else {
                DispatchQueue.main.async {
                    text = "File not found"
                }
                return
            }
            
            do {
                let content = try String(contentsOfFile: path, encoding: .utf8)
                DispatchQueue.main.async {
                    text = content
                }
            } catch {
                DispatchQueue.main.async {
                    text = "Error loading file."
                }
            }
        }
    }
    
    var body: some View {
        VStack {
            TextEditor(text: $text)
                .padding()
                .border(Color.gray, width: 1)
                .disableAutocorrection(true)
                .lineSpacing(5)
        }
        .onAppear() {
            if let file = vm.currentFile {
                loadTextFile(atPath: file.url.path)
            }
        }
        .onChange(of: vm.currentFile) { oldValue, newValue in
            if let file = vm.currentFile {
                loadTextFile(atPath: file.url.path)
            }
        }
    }
}
