//
//  File.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//

import SwiftUI

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
    var icon: Image {
        return Image(systemName: "document")
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
