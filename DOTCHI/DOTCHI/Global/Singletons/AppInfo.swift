//
//  AppInfo.swift
//  DOTCHI
//
//  Created by Jungbin on 7/10/24.
//

import Foundation

final class AppInfo {
    static var shared = AppInfo()
    
    init() { }
    
    func currentAppVersion() -> String {
        return Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String ?? "0.0.0"
    }
}
