//
//  URL+Extensions.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/16/25.
//

import Foundation

extension URL {
    func removingLastPathComponentIfFile() -> URL? {
        guard isFileURL else {
            print("URL is not a file URL.")
            return nil
        }

        guard pathComponents.count > 1 else {
            print("URL has no path components to remove.")
            return self // Or nil if you prefer to return nothing in this case
        }

        return deletingLastPathComponent()
    }
    
    func appendingPathComponentIfFile(_ pathComponent: String) -> URL? {
        guard isFileURL else {
            print("URL is not a file URL.")
            return nil
        }

        return appendingPathComponent(pathComponent)
    }

    func appendingPathComponentsIfFile(_ pathComponents: [String]) -> URL? {
        guard isFileURL else {
            print("URL is not a file URL.")
            return nil
        }

        var newURL = self

        for component in pathComponents {
            newURL.appendPathComponent(component)
        }
        
        return newURL
    }
}
