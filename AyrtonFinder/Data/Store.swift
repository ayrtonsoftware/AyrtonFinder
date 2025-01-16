//
//  Store.swift
//  Zora
//
//  Created by Michael Bergamo on 12/19/21.
//

import Foundation
import RealmSwift

public class Store {
    public static var baseDir: String?
    private var dirUrl: URL
    private var fileUrl: URL
    private var classes: [ObjectBase.Type]
    private var storeType: String = ""
    private var inMemory: Bool = false
    private var schemaVersion: UInt64
    private var config: Realm.Configuration?
    
    public init(name: String,
                key: String,
                classes: [ObjectBase.Type],
                schemaVersion: UInt64,
                inMemory: Bool = false) {
        self.inMemory = inMemory
        self.schemaVersion = schemaVersion
        
        dirUrl = URL(fileURLWithPath: String.getDocumentsDirectory())
        if let baseDir = Store.baseDir {
            dirUrl = dirUrl.appendingPathComponent(baseDir)
        }
        dirUrl = dirUrl.appendingPathComponent(key)
        let fileUrl = dirUrl.appendingPathComponent("facts.realm")
        print("+------------------------------------------")
        print("|   realm: \(fileUrl.path)")
        print("+------------------------------------------")
        self.fileUrl = fileUrl
        self.classes = classes
        let className = String(describing: type(of: self))
        storeType = "--\(className)--\(key)--"
    }
    
    private func ensureFolderExists() throws {
        if !FileManager.default.fileExists(atPath: dirUrl.path) {
            try FileManager.default.createDirectory(at: dirUrl, withIntermediateDirectories: true)
        }
    }
    
    public func getConfig() -> Realm.Configuration? {
        do {
            try ensureFolderExists()
            if inMemory {
            } else {
                return Realm.Configuration(
                    fileURL: fileUrl,
                    schemaVersion: schemaVersion,
                    migrationBlock: { migration, oldSchemaVersion in
                        print("Version \(oldSchemaVersion)")
                    },
                    shouldCompactOnLaunch: {totalBytes, usedBytes in
                        print("Should Compact on Launch total \(totalBytes) used \(usedBytes)")
                        return false
                    },
                    objectTypes: classes
                )
            }
        }
        catch {
            // TODO: log error
            print("Store: \(error.localizedDescription)")
        }
        return nil
    }
    
    static func delete(obj: Object) {
        do {
            var wrealm: Realm? = obj.realm
            var realmWasFrozen = false
            if ((wrealm?.isFrozen) != nil) {
                wrealm = wrealm?.thaw()
                realmWasFrozen = true
            }
            if let w2realm = wrealm {
                if obj.isFrozen {
                    if let world = obj.thaw() {
                        try w2realm.write {
                            w2realm.delete(world)
                        }
                    } else {
                        w2realm.delete(obj)
                    }
                } else {
                    w2realm.delete(obj)
                }
                if realmWasFrozen {
                    _ = w2realm.freeze()
                }
            }
        }
        catch {
            print("Error: \(error.localizedDescription)")
        }
    }
}
