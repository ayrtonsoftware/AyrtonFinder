////
////  Finder.swift
////  Zora2Import
////
////  Created by Michael Bergamo on 1/14/25.
////

import SwiftUI
import Combine

public struct FinderView: View {
    @ObservedObject var vm: FinderVM
    
    public init(vm: FinderVM) {
        self.vm = vm
    }
    
    public var body: some View {
        VStack {
            Text("Folders")
            HStack {
                Button {
                    vm.pop()
                } label: {
                    Text("Pop")
                }
                Button {
                    vm.reload()
                } label: {
                    Text("Reload")
                }
            }
            Toggle("Hidden Files:", isOn: $vm.showHiddenFiles)
                .onChange(of: vm.showHiddenFiles) { oldValue, newValue in
                    vm.reload()
                }
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    ForEach(vm.currentFolder.files.indices, id: \.self) { index in // Use indices for alternating rows
                        let file = vm.currentFolder.files[index]
                        let isHiddenFile = file.url.lastPathComponent.starts(with: ".")
                        if (isHiddenFile && vm.showHiddenFiles) || !isHiddenFile {
                            FilenameView(path: file.url.path,
                                         filename: file.url.lastPathComponent,
                                         isSelected: false,
                                         fileExtension: file.url.pathExtension,
                                         isFolder: file.isFolder) {
                                print("Selected: \(file.url.lastPathComponent)")
                                if file.isFolder {
                                    vm.push(file: file)
                                } else {
                                    vm.currentFile = file
                                }
                            }
                            .background(index.isMultiple(of: 2) ? Color.secondary.opacity(0.1) : Color.clear) // Alternating background
                        }
                    }
                }
            }
        }
        .border(.gray, width: 1)
    }
}
