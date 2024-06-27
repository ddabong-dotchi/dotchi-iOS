//
//  Messages.swift
//  DOTCHI
//
//  Created by Jungbin on 6/27/24.
//

import Foundation

enum Messages {
    case networkError
    case completedReport
}

extension Messages {
    
    var text: String {
        switch self {
        case .networkError:
            return
"""
네트워크 오류로 인해 연결에 실패하였습니다.
잠시 후에 다시 시도해 주세요.
"""
        case .completedReport:
            return "신고가 접수되었습니다."
        }
    }
}
