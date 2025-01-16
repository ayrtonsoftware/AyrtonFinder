//
//  ImageView.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct Item: Identifiable {
    let id = UUID()
    let name: String
    let value: String
}

struct AnnotatedItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct ImageView: View {
    @State private var image: NSImage? = nil // State variable for the image
    @ObservedObject var vm: FinderVM
    @State var gps: CLLocationCoordinate2D?
    @State var region = MKCoordinateRegion()
    @State var items: [Item] = []
    @State private var scrollViewID = UUID()
    
    func loadImage(file: File) {
        do {
            gps = nil
            items.removeAll()
            let imageData = try Data(contentsOf: file.url)
            guard let image = NSImage(data: imageData) else {
                return
            }
            self.image = image
            var (exif, gps) = try Image.getExif(from: file.url)
            self.gps = gps
            if let coordinate = gps {
                self.region = MKCoordinateRegion(
                    center: coordinate,
                    span: MKCoordinateSpan(latitudeDelta: 0.02, longitudeDelta: 0.02) // Adjust zoom level
                )
            }
            for (key, value) in exif {
                items.append(Item(name: key, value: "\(value)"))
            }
            items.sort(by: {$0.name < $1.name})
            print("Item count: \(items.count)")
            scrollViewID = UUID()
        }
        catch {
            print("loadImage error: \(error)")
        }
    }
    
    var body: some View {
        VStack {
            VSplitView {
                if let image = image {
                    Image(nsImage: image)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                }
                if let gps = self.gps {
                    Divider()
                        .frame(height: 4)
                        .overlay(.blue)
                    Map(coordinateRegion: $region, annotationItems: [AnnotatedItem(coordinate: gps)]) { item in
                        MapMarker(coordinate: item.coordinate)
                    }
                }
                if let firstItem = items.first {
                    Divider()
                        .frame(height: 4)
                        .overlay(.blue)
                    ScrollViewReader { proxy in
                        ScrollView {
                            ForEach(items.indices, id: \.self) { index in
                                HStack {
                                    Text(items[index].name)
                                        .frame(maxWidth: .infinity, alignment: .leading)
                                    Text(String(items[index].value))
                                        .frame(maxWidth: .infinity, alignment: .trailing) // Expand to fill column and align right
                                }
                                .id(items[index].id)
                                .padding(.vertical, 8) // Add some vertical padding
                                .listRowSeparator(.hidden) // Hide default separators
                                .background(index.isMultiple(of: 2) ? Color.white : Color.gray.opacity(0.2)) // Alternate background colors
                            }
                        }
                        .id(self.scrollViewID)
                    }
                }
            }
        }
        .onAppear {
            if let file = vm.currentFile {
                loadImage(file: file)
            }
        }
        .onChange(of: vm.currentFile) { oldValue, newValue in
            if let file = vm.currentFile {
                loadImage(file: file)
            }
        }
    }
}
