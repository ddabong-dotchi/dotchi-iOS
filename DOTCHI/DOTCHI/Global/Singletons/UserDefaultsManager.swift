//
//  UserDefaultsManager.swift
//  DOTCHI
//
//  Created by Jungbin on 6/27/24.
//

import Foundation

struct UserDefaultsManager {
    static var isSigned: Bool? {
        get { return UserDefaults.standard.bool(forKey: UserDefaults.Keys.isSigned.rawValue) }
        set { UserDefaults.standard.set(newValue, forKey: UserDefaults.Keys.isSigned.rawValue) }
    }
}
