//
//  UserDefaultsProvider.swift
//  Meminter
//
//  Created by Холмогоров Дмитрий on 05.11.2020.
//

import Foundation

protocol UserDefaultsProviderInput: AnyObject {
    func checkFor(key: UserDefaultsKeys) -> Bool
    func save(value: Bool, for key: UserDefaultsKeys)
}

final class UserDefaultsProvider: UserDefaultsProviderInput {
    func checkFor(key: UserDefaultsKeys) -> Bool {
        return UserDefaults.standard.bool(forKey: key.rawValue)
    }
    
    func save(value: Bool, for key: UserDefaultsKeys) {
        UserDefaults.standard.set(value, forKey: key.rawValue)
    }
}
