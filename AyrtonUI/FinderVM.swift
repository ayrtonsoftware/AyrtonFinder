//
//  FinderVM.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//

import SwiftUI
import Combine

public class FinderVM: ObservableObject {
    @Published public var title: String = "Finder"
    //@Published public var folders: [Folder] = []
    @Published public var currentFolder: Folder
    @Published public var currentFile: File?
    @Published public var showHiddenFiles: Bool = false
    
    public init(path: String = "/") {
        let rootURL = URL(fileURLWithPath: path)
        let rootFolder = Folder(url: rootURL)
        currentFolder = rootFolder
        rootFolder.load(addHiddenFiles: showHiddenFiles)
        //folders.append(rootFolder)
    }

    func reload() {
        let newFolder = Folder(url: currentFolder.url)
        newFolder.load(addHiddenFiles: showHiddenFiles)
        currentFolder = newFolder
        //folders.removeLast()
        //folders.append(newFolder)
    }
    
    func pop() {
        if currentFolder.url.path != "/" {
            if let url = currentFolder.url.removingLastPathComponentIfFile() {
                let folder = Folder(url: url)
                folder.load(addHiddenFiles: showHiddenFiles)
                currentFolder = folder
            }
        }
//        if folders.count > 1 {
//            folders.removeLast()
//            if let topFolder = folders.last {
//                currentFolder = topFolder
//                currentFolder.load()
//            }
//        }
    }
    
    func push(file: File) {
        if file.isFolder {
            let url = currentFolder.url.appendingPathComponent(file.url.lastPathComponent)
            print("Pushing \(url.path)")
            let folder = Folder(url: url)
            folder.load(addHiddenFiles: showHiddenFiles)
            currentFolder = folder
        }
    }
}
