//
//  String+Extensions.swift
//  xevious
//
//  Created by Michael Bergamo on 9/27/23.
//

#if TARGET_OS_IOS
import UIKit
#endif
import Foundation

extension String {
    enum BundleError: Error {
      case resourceNotFound
    }
    
    #if TARGET_OS_IOS
    func base64ToImage() -> UIImage? {
        var img: UIImage = UIImage()
        if (!isEmpty) {
            if let decodedData = NSData(base64Encoded: self, options: NSData.Base64DecodingOptions.ignoreUnknownCharacters) {
                if let decodedimage = UIImage(data: decodedData as Data) {
                    img = (decodedimage as UIImage?)!
                    return img
                }
            }
        }
        return nil
    }
    #endif
    
    func contentsOf() -> String? {
        let str = NSString(string: self)
        if let filepath = Bundle.main.path(forResource: str.deletingPathExtension, ofType: str.pathExtension) {
            do {
                let xml = try String(contentsOfFile: filepath)
                return xml
            }
            catch {
                
            }
        }
        return nil
    }
    
    func groups(names: [String], for filter: String) -> [String:String] {
        let lineRange = NSRange(
            self.startIndex..<self.endIndex,
            in: self
        )
        let captureRegex = try! NSRegularExpression(
            pattern: filter,
            options: []
        )
        let matches = captureRegex.matches(
            in: self,
            options: [],
            range: lineRange
        )
        
        var captures: [String: String] = [:]
        
        guard let match = matches.first else {
            return captures
        }
        
        for name in names {
            let matchRange = match.range(withName: name)
            
            // Extract the substring matching the named capture group
            if let substringRange = Range(matchRange, in: self) {
                let capture = String(self[substringRange])
                captures[name] = capture
            }
        }
        return captures
    }
    
    func stringByTrimmingLeadingAndTrailingWhitespace() -> String {
        return self.trimmingCharacters(in: CharacterSet.whitespacesAndNewlines)
    }
    
    func toDouble() -> Double? {
        return NumberFormatter().number(from: self)?.doubleValue
    }
    
    func stringByAppendingPathComponent(path: String) -> String
    {
        let nsSt = self as NSString
        return nsSt.appendingPathComponent(path)
    }
    
    static func getDocumentsDirectory() -> String {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentsDirectory = paths[0]
        return documentsDirectory.path
    }
    
    static func getTempDirectory() -> String {
        return NSTemporaryDirectory()
    }
    
    var dateFromISO8601: Date?
    {
        return Date.iso8601Formatter.date(from: self)
    }
    
    func regexMatch(pattern: String) -> Bool
    {
        let regex = try! NSRegularExpression(pattern: pattern, options: [])
        let matches = regex.numberOfMatches(in: self, options: [], range: NSRange(location: 0, length: self.count))
        //return matches == 1
        return matches > 0
    }
    
    // str.padEnd(8, "-")
    func padEnd(_ length: Int, _ pad: String) -> String {
        return padding(toLength: length, withPad: pad, startingAt: 0)
    }
    
    // str.padStart(8, "*")
    func padStart(_ length: Int, _ pad: String) -> String {
        let str = String(self.reversed())
        return String(str.padEnd(length, pad).reversed())
    }
    
    func versionCompare(_ otherVersion: String) -> ComparisonResult {
        let versionDelimiter = "."
        
        var versionComponents = self.components(separatedBy: versionDelimiter) // <1>
        var otherVersionComponents = otherVersion.components(separatedBy: versionDelimiter)
        
        let zeroDiff = versionComponents.count - otherVersionComponents.count // <2>
        
        if zeroDiff == 0 { // <3>
            // Same format, compare normally
            return self.compare(otherVersion, options: .numeric)
        } else {
            let zeros = Array(repeating: "0", count: abs(zeroDiff)) // <4>
            if zeroDiff > 0 {
                otherVersionComponents.append(contentsOf: zeros) // <5>
            } else {
                versionComponents.append(contentsOf: zeros)
            }
            return versionComponents.joined(separator: versionDelimiter)
                .compare(otherVersionComponents.joined(separator: versionDelimiter), options: .numeric) // <6>
        }
    }
    
    static func loadEmbeddedFileAsString(fileName: String) throws -> String {
        let bundle = Bundle.main
        guard let filePath = bundle.path(forResource: fileName, ofType: nil) else {
            throw BundleError.resourceNotFound
        }
        
        let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
        return String(decoding: data, as: UTF8.self)
    }
    
    func splitFilename() -> (name: String, extension: String) {
      let url = URL(fileURLWithPath: self)
      let name = url.deletingPathExtension().lastPathComponent
      let ext = url.pathExtension
      return (name, ext)
    }
    
//    static func loadEmbeddedResourceString(name: String, ext: String) -> String? {
//        guard let url = Bundle.main.url(forResource: name, withExtension: ext) else {
//            print("Resource not found")
//            return nil
//        }
//
//        guard let data = try? Data(contentsOf: url) else {
//            print("Error loading resource data")
//            return nil
//        }
//
//        guard let string = String(data: data, encoding: .utf8) else {
//            print("Error converting data to string")
//            return nil
//        }
//
//        return string
//    }
}
