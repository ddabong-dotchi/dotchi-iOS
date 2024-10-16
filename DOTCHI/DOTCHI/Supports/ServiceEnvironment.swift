//
//  ServiceEnvironment.swift
//  DOTCHI
//
//  Created by Jungbin on 7/11/24.
//

import Foundation

enum ServiceEnvironment: String {
    case debug = "debug"
    case qa = "qa"
    case release = "release"
    
    enum Keys {
        enum Plist {
            static let baseUrl = "BASE_URL"
            static let imageBaseUrl = "IMAGE_BASE_URL"
            static let facebookAppId = "FacebookAppID"
        }
    }
    
    static let infoDictionary: [String: Any] = {
        guard let dict = Bundle.main.infoDictionary else { fatalError() }
        return dict
    }()
    
    static let BASE_URL: String = {
        guard let string = ServiceEnvironment.infoDictionary[Keys.Plist.baseUrl] as? String else {
            fatalError("Base URL not set in plist for this environment")
        }
        return string
    }()
    
    static let IMAGE_BASE_URL: String = {
        guard let string = ServiceEnvironment.infoDictionary[Keys.Plist.imageBaseUrl] as? String else {
            fatalError("Image Base URL not set in plist for this environment")
        }
        return string
    }()
    
    static let FACEBOOK_APP_ID: String = {
        guard let string = ServiceEnvironment.infoDictionary[Keys.Plist.facebookAppId] as? String else {
            fatalError("FACEBOOK_APP_ID not set in plist for this environment")
        }
        return string
    }()
}

func env() -> ServiceEnvironment {
    #if DEBUG
    return .debug
    #elseif QA
    return .qa
    #elseif RELEASE
    return .release
    #endif
}
