//
//  FinderStore.swift
//  AyrtonFinder
//
//  Created by Michael Bergamo on 1/15/25.
//

import RealmSwift

public class LocalPathBookmark: Object {
    @Persisted var path: String
}

public class SmbServer: Object {
    @Persisted var name: String
    @Persisted var address: String
    @Persisted var password: String
}

func getStoreConfig() -> Realm.Configuration?
{
    let store = FinderStore()
    let config = store.getConfig()
    print("+------------------------------------------")
    if let obj = config, let url = obj.fileURL {
        print("|   realm: \(url)")
    } else {
        print("|   realm: failed")
    }
    print("+------------------------------------------")
    return config
}

func getRealm() -> Realm? {
    guard let config = getStoreConfig() else {
        return nil
    }
    do {
        let realm = try Realm(configuration: config)
        return realm
    }
    catch {
        print("getRealm error: \(error)")
    }
    return nil
}

class FinderStore: Store {
    public init(base: String? = nil) {
        super.init(name: "FinderStore",
                   key: "FinderStore",
                   classes:
                    [
                        SmbServer.self,
                        LocalPathBookmark.self
                    ], schemaVersion: 5)
    }
}
