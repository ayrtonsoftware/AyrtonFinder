//
//  PListView.swift
//  AyrtonUI
//
//  Created by Michael Bergamo on 1/15/25.
//

import SwiftUI

import SwiftUI

struct InfoPlistView: View {
    @ObservedObject var vm: FinderVM

    @State private var infoPlistData: [String: Any]?
    @State private var errorMessage: String?

    var body: some View {
        ScrollView { // Use ScrollView for larger lists
            LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 10) { // Two flexible columns
                if let infoPlistData = infoPlistData {
                    ForEach(infoPlistData.sorted(by: { $0.key < $1.key }), id: \.key) { key, value in
                        Text(key)
                            .bold()
                            .frame(maxWidth: .infinity, alignment: .leading) // Align key to the left
                        Text(String(describing: value))
                            .lineLimit(3)
                            .truncationMode(.tail)
                            .frame(maxWidth: .infinity, alignment: .leading) // Align value to the left
                    }
                } else if let errorMessage = errorMessage {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity, alignment: .center) // Center the error message
                } else {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center) // Center the progress view
                }
            }
            .padding() // Add padding around the grid
        }
        .navigationTitle(vm.currentFolder.url.lastPathComponent)
        .onAppear {
            loadInfoPlist()
        }
    }

    private func loadInfoPlist() {
        do {
            guard let url = vm.currentFile?.url else {
                return
            }
            let data = try Data(contentsOf: url)
            if let plist = try PropertyListSerialization.propertyList(from: data, options: [], format: nil) as? [String: Any] {
                infoPlistData = plist
            } else {
                errorMessage = "Invalid Info.plist format"
            }
        } catch {
            errorMessage = "Error loading Info.plist: \(error.localizedDescription)"
        }
    }
}
