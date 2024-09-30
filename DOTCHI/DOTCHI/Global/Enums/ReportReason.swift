//
//  ReportReason.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 10/1/24.
//

import Foundation

enum ReportReason: String {
    case harmful = "HARMFUL"
    case plaster = "PLASTER"
    case poach = "POACH"
    case spam = "SPAM"
    case other = "OTHER"
}

extension String {
    func toReportReason() -> ReportReason {
        switch self {
        case "유해한 콘텐츠": return .harmful
        case "도배": return .plaster
        case "도용": return .poach
        case "스팸/홍보": return .spam
        case "기타": return .other
        default: return .other
        }
    }
}
