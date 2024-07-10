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
    case unabledMailApp
    case completedSendContactMail
    case failedSendContactMail
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
            
        case .unabledMailApp:
            return "Mail 앱을 사용할 수 없습니다. 기기에 Mail 앱이 설치되어 있는지 확인해 주세요."
            
        case .completedSendContactMail:
            return "메일 전송이 완료되었습니다."
            
        case .failedSendContactMail:
            return "메일 전송에 실패하였습니다. 다시 시도해 주세요."
        }
    }
}
