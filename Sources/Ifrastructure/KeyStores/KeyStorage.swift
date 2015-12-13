//
//  KeyStorage.swift
//  YMoney
//
//  Created by Nikolay Morev on 13/12/15.
//  Copyright © 2015 DMA. All rights reserved.
//

import Foundation

enum KeyStorageError : ErrorType {
    case InvalidDefaultsValue
    case InvalidArchivedData
}

class KeyStorage : NSObject {

    private lazy var store: [String : AnyObject] = [:]
    private static let defaultToken = "41001773456006.C561C4B1E9545B58E724FFA6DE0D6CF8B73482A87D90D0BE94010E1BB301E88074D262E51CC801177388E8C6B4FE4A3905EB97341F3266B3BB0ECEE5123A01B3734DC89F6E9416872B637A0A39EE823EFE39A1D5770DAB9B8E0998ED6937D2346F05C1876A223349E133CC20DF49D864965DE5807F23327E7C19964B51F09BAA"

    private override init() {
    }

    static func forTest() -> KeyStorage {
        let storage = KeyStorage()
        storage.store["Token"] = defaultToken

        let account = YMAAccountInfoModel.accountInfoWithAccount("105043", balance: "109", currency: "P", accountStatus: .Unknown, accountType: .Unknown, avatar: nil, balanceDetails: nil, cardsLinked: nil, servicesAdditional: nil, yamoneyCards: nil);
        storage.store["Account"] = account

        return storage
    }

    func loadDataForKey(key: String) throws -> AnyObject {
        if let data = store[key] {
            return data
        }
        else {
            let defaults = NSUserDefaults.standardUserDefaults()
            guard let data = defaults.objectForKey(key) as? NSData else {
                throw KeyStorageError.InvalidDefaultsValue
            }
            guard let obj = NSKeyedUnarchiver.unarchiveObjectWithData(data) else {
                throw KeyStorageError.InvalidArchivedData
            }
            return obj
        }
    }

    func saveData(data: AnyObject, forKey key: String) -> Bool {
        store[key] = data
        let archivedData = NSKeyedArchiver.archivedDataWithRootObject(data),
            defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(archivedData, forKey: key)
        return defaults.synchronize()
    }

    func deleteData(forKey key: String) -> Bool {
        store[key] = nil
        return true;
    }

    func cleanKeyStorage() -> Bool {
        store.removeAll()
        if let appDomain = NSBundle.mainBundle().bundleIdentifier {
            NSUserDefaults.standardUserDefaults().removePersistentDomainForName(appDomain)
        }
        return true
    }

}
