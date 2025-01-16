//
//  FileRow.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//
//
import SwiftUI
import UniformTypeIdentifiers

struct FileItem: Identifiable {
    let id = UUID()
    let filename: String
    let fileExtension: String?
    let action: () -> Void
}

struct FilenameView: View {
    let path: String
    let filename: String
    let isSelected: Bool
    let fileExtension: String?
    let isFolder: Bool?
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(spacing: 4) {
                FileIconView(path: path)
                    .padding(4)
                Text(filename)
                    .font(.system(size: 13))
                    .lineLimit(1)
                    .truncationMode(.middle)
                    .foregroundColor(.primary)

                if let fileExtension = fileExtension {
                    Text(".\(fileExtension)")
                        .font(.system(size: 10))
                        .foregroundColor(.secondary)
                }
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .contentShape(Rectangle())
            .background(isSelected ? Color.accentColor.opacity(0.2) : Color.clear) // Selection highlight here
            .cornerRadius(6)
            .padding(.vertical, 2)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

//import SwiftUI
//
//struct FileRow: View {
//    let file: File // Replace YourFileType with your actual file type
//    let isOdd: Bool // To determine background color
//    let action: () -> Void
//
//    var body: some View {
//        HStack(spacing: 8) {
//            file.icon
//            Text("\(isOdd)-\(file.url.lastPathComponent)")
//            Spacer()
//        }
//    }
//    
//    var body2: some View {
//        Button(action: action) {
//            HStack(spacing: 8) {
//                file.icon
//                Text("\(isOdd)-\(file.url.lastPathComponent)")
//                Spacer()
//            }
//            .border(.clear, width: 0)
//            //.padding(.vertical, 4)
//            //.padding(.horizontal, 8)
//            .background(isOdd ? Color.secondary.opacity(0.4) : Color.white)
//        }
//    }
//}

//import SwiftUI
//
//struct FileItem: Identifiable {
//    let id = UUID()
//    let filename: String
//    let fileExtension: String?
//    let iconName: String?
//}
//
//struct FilenameView: View {
//    let filename: String
//    let fileExtension: String?
//    let iconName: String?
//    let action: () -> Void // Closure for the action
//
//    var body: some View {
//        Button(action: action) { // Wrap in a Button
//            HStack(spacing: 4) {
//                if let iconName = iconName {
//                    Image(systemName: iconName)
//                        .font(.system(size: 13))
//                        .foregroundColor(.secondary)
//                }
//
//                Text(filename)
//                    .font(.system(size: 13))
//                    .lineLimit(1)
//                    .truncationMode(.middle)
//                    .foregroundColor(.primary) // Ensure text is visible on selection
//
//                if let fileExtension = fileExtension {
//                    Text(".\(fileExtension)")
//                        .font(.system(size: 10))
//                        .foregroundColor(.secondary)
//                }
//            }
//            .contentShape(Rectangle()) // Make the entire row tappable
//        }
//        .buttonStyle(PlainButtonStyle()) // Remove button styling
//    }
//}
//
//struct ContentView: View {
//    @State private var selection: UUID?
//    let fileItems: [FileItem] = [
//        FileItem(filename: "Document", fileExtension: "pdf", iconName: "doc.richtext"),
//        FileItem(filename: "VeryLongFileNameThatNeedsToBeTruncated", fileExtension: "txt", iconName: "doc.text"),
//        FileItem(filename: "Image", fileExtension: "jpg", iconName: "photo"),
//        FileItem(filename: "Folder", fileExtension: nil, iconName: "folder"),
//        FileItem(filename: "AnotherVeryLongFileNameThatNeedsToBeTruncatedButWithAnEvenLongerName", fileExtension: "swift", iconName: "swift"),
//        FileItem(filename: "Short", fileExtension: "app", iconName: "app")
//    ]
//
//    var body: some View {
//        List(fileItems, selection: $selection) { fileItem in
//            FilenameView(filename: fileItem.filename, fileExtension: fileItem.fileExtension, iconName: fileItem.iconName) {
//                // Action to perform when the filename is clicked
//                print("Clicked on \(fileItem.filename)")
//                // Add your custom logic here, e.g., open the file, navigate to a new view, etc.
//            }
//            .listRowBackground(
//                RoundedRectangle(cornerRadius: 6)
//                    .fill(selection == fileItem.id ? Color.accentColor.opacity(0.2) : Color.clear)
//                    .padding(.vertical, 2)
//            )
//        }
//        .listStyle(.sidebar)
//        .frame(width: 300, height: 400)
//        .navigationTitle("Files")
//    }
//}
//
//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        ContentView()
//    }
//}
