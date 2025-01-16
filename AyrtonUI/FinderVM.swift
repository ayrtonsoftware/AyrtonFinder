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
    @Published public var folders: [Folder] = []
    @Published public var currentFolder: Folder
    @Published public var currentFile: File?
    @Published public var showHiddenFiles: Bool = false
    
    public init(path: String = "/") {
        let rootURL = URL(fileURLWithPath: path)
        let rootFolder = Folder(url: rootURL)
        rootFolder.load()
        currentFolder = rootFolder
        folders.append(rootFolder)
    }

    func reload() {
        let newFolder = Folder(url: currentFolder.url)
        newFolder.load()
        currentFolder = newFolder
        folders.removeLast()
        folders.append(newFolder)
    }
    
    func pop() {
        if folders.count > 1 {
            folders.removeLast()
            if let topFolder = folders.last {
                currentFolder = topFolder
                currentFolder.load()
            }
        }
    }
    
    func push(file: File) {
        if file.isFolder {
            print("Pushing \(file.url.absoluteString)")
            let folder = Folder(url: file.url)
            folder.load()
            folders.append(folder)
            currentFolder = folder
            currentFolder.load()
        }
    }
}
