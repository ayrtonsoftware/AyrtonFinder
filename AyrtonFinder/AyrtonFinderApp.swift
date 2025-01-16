//
//  AyrtonFinderApp.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//

import SwiftUI
import AyrtonUI
import RealmSwift

class AyrtonFinderAppVM: ObservableObject {
    
}

@main
struct AyrtonFinderApp: SwiftUI.App {
    @ObservedObject private var fvm = FinderVM()
    @ObservedObject private var avm = AyrtonFinderAppVM()
    
    private func setup() {
        print("AyrtonFinder::setup")
        if let realm = getRealm() {
            print("AyrtonFinder::setup got realm")
        }
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationSplitView {
                FinderView(vm: fvm)
            } detail: {
                VStack {
                    Text(fvm.currentFolder.url.lastPathComponent)
                    if let file = fvm.currentFile {
                        Text(file.url.lastPathComponent)
                    }
                    FileView(vm: fvm)
                }
                .onAppear {
                    setup()
                }
            }
        }
    }
}
