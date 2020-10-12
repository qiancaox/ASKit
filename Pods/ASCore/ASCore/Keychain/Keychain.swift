//  Keychain.swift
//  Copyright © 2020 Amt Super. All rights reserved.

import SAMKeychain

/// Sotrage some essential informations.

final public class Keychain {
    
    internal struct StorageKeys {
        static let Service = "Keychain_Service_Name"
        static let Password = "Keychain_Passowrd"
        static let Account = "Keychain_Account"
        static let Token = "Keychain_Token"
        static let UUID = "Keychain_UUID"
    }
    
    /// Store login password in keychain.
    public static var password: String? {
        get {
            return SAMKeychain.password(forService: StorageKeys.Service, account: StorageKeys.Password)
        }
        
        set {
            if let _ = newValue, newValue!.count > 0 {
                SAMKeychain.setPassword(newValue!, forService: StorageKeys.Service, account: StorageKeys.Password)
            } else {
                SAMKeychain.deletePassword(forService: StorageKeys.Service, account: StorageKeys.Password)
            }
        }
    }
    /// Store login account in keychain.
    public static var account: String? {
        get {
            return SAMKeychain.password(forService: StorageKeys.Service, account: StorageKeys.Account)
        }
        
        set {
            if let _ = newValue, newValue!.count > 0 {
                SAMKeychain.setPassword(newValue!, forService: StorageKeys.Service, account: StorageKeys.Account)
            } else {
                SAMKeychain.deletePassword(forService: StorageKeys.Service, account: StorageKeys.Account)
            }
        }
    }
    /// Store access token in keychain.
    public static var token: String? {
        get {
            return SAMKeychain.password(forService: StorageKeys.Service, account: StorageKeys.Token)
        }
        
        set {
            if let _ = newValue, newValue!.count > 0 {
                SAMKeychain.setPassword(newValue!, forService: StorageKeys.Service, account: StorageKeys.Token)
            } else {
                SAMKeychain.deletePassword(forService: StorageKeys.Service, account: StorageKeys.Token)
            }
        }
    }
    /// Get the login state by using token, password and account.
    public static var isLogin: Bool {
        if password != nil && token != nil && account != nil {
            return true
        }
        return false
    }
    
}
