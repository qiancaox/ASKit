//  Keychain+UUID.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import SAMKeychain

public extension Keychain {
        
    /// Get the device UUID in keychain. If not in keychain, create it.
    static var UUID: String {
        guard let uuid = SAMKeychain.password(forService: StorageKeys.Service, account: StorageKeys.UUID) else {
            let uuid = CFUUIDCreate(nil)!
            let string = CFUUIDCreateString(nil, uuid)!
            SAMKeychain.setPassword(String(string), forService: StorageKeys.Service, account: StorageKeys.UUID)
            return String(string)
        }
        return uuid
    }
    
}
