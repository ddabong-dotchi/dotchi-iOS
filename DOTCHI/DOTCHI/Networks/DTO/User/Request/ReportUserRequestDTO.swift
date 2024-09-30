//
//  ReportUserRequestDTO.swift
//  DOTCHI
//
//  Created by Jungbin Jung on 10/1/24.
//

import Foundation

struct ReportUserRequestDTO: Encodable {
    var target: String
    var reportReason: String
    
    init() {
        self.target = ""
        self.reportReason = ""
    }
}
