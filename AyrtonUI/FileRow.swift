//
//  FileRow.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//

import SwiftUI

struct FileRow: View {
    let file: File // Replace YourFileType with your actual file type
    let isOdd: Bool // To determine background color
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                file.icon
                Text(file.url.lastPathComponent)
                Spacer()
            }
            .padding(.vertical, 4) // Add some vertical padding
            .padding(.horizontal, 8)
            .background(isOdd ? Color.secondary.opacity(0.1) : Color.clear) // Apply background color based on isOdd
        }
    }
}
