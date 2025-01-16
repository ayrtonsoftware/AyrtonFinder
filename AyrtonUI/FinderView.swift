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
            Button {
                vm.pop()
            } label: {
                Text("Pop")
            }
            Toggle("Hidden Files:", isOn: $vm.showHiddenFiles)
            ScrollView {
                VStack(alignment: .leading, spacing: 0) { // Important: Set spacing to 0
                    ForEach(vm.currentFolder.files.indices, id: \.self) { index in // Use indices for alternating rows
                        let file = vm.currentFolder.files[index]
                        let isHiddenFile = file.url.lastPathComponent.starts(with: ".")
                        if (isHiddenFile && vm.showHiddenFiles) || !isHiddenFile {
                            FileRow(file: vm.currentFolder.files[index],
                                    isOdd: index % 2 != 0,
                                    action: {
                                if file.isFolder {
                                    vm.push(file: file)
                                } else {
                                    vm.currentFile = file
                                }
                            })
                        }
                    }
                }
            }
        }
    }
}
