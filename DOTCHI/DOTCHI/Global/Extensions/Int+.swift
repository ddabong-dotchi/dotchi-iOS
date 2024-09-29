//
//  Int+.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 9/29/24.
//

extension Int {
    func toLuckyType() -> LuckyType {
        switch self {
        case 1: return .lucky
        case 2: return .love
        case 3: return .health
        case 4: return .money
        default:
            return .lucky
        }
    }
}
