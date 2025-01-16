//
//  ImageView.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//

import SwiftUI
import CoreLocation
import MapKit

struct AnnotatedItem: Identifiable {
    let id = UUID()
    let coordinate: CLLocationCoordinate2D
}

struct ImageView: View {
    @State private var image: NSImage? = nil // State variable for the image
    @ObservedObject var vm: FinderVM
    @State var gps: CLLocationCoordinate2D?
    @State var region = MKCoordinateRegion()
    
    func loadImage(file: File) {
        do {
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
        }
        catch {
            print("loadImage error: \(error)")
        }
    }
    
    var body: some View {
        VStack {
            if let image = image {
                Image(nsImage: image)
                    .resizable()
                    .aspectRatio(contentMode: .fit)
            }
            if let gps = self.gps {
                Map(coordinateRegion: $region, annotationItems: [AnnotatedItem(coordinate: gps)]) { item in
                    MapMarker(coordinate: item.coordinate)
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
