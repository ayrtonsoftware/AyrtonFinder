//
//  Image+Extensions.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//

import Foundation
import SwiftUI
import ImageIO
import CoreLocation

enum EXIFError: Error {
    case fileNotFound
    case invalidImageData
    case noEXIFData
}

extension Image {
    static func getExif(from url: URL) throws -> ([String: Any], CLLocationCoordinate2D?) {
        guard FileManager.default.fileExists(atPath: url.path) else {
            throw EXIFError.fileNotFound
        }
        
        guard let imageSource = CGImageSourceCreateWithURL(url as CFURL, nil) else {
            throw EXIFError.invalidImageData
        }
        
        guard let imageProperties = CGImageSourceCopyPropertiesAtIndex(imageSource, 0, nil) as? [String: Any] else {
            throw EXIFError.invalidImageData
        }
        
        guard let exifData = imageProperties[kCGImagePropertyExifDictionary as String] as? [String: Any] else {
            throw EXIFError.noEXIFData
        }
        
        var gps: CLLocationCoordinate2D?

        if let gpsData = imageProperties[kCGImagePropertyGPSDictionary as String] as? [String: Any],
           let latitudeRef = gpsData[kCGImagePropertyGPSLatitudeRef as String] as? String,
           let latitude = gpsData[kCGImagePropertyGPSLatitude as String] as? Double,
           let longitudeRef = gpsData[kCGImagePropertyGPSLongitudeRef as String] as? String,
           let longitude = gpsData[kCGImagePropertyGPSLongitude as String] as? Double {
            let latSign = latitudeRef == "N" ? 1.0 : -1.0
            let lonSign = longitudeRef == "E" ? 1.0 : -1.0
            let coordinate = CLLocationCoordinate2D(latitude: latSign * latitude, longitude: lonSign * longitude)
            gps = coordinate
        }
        
        return (exifData, gps)
    }
}
