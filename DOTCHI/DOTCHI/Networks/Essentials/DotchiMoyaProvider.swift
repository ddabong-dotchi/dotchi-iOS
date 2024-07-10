//
//  DotchiMoyaProvider.swift
//  DOTCHI
//
//  Created by Jungbin on 7/10/24.
//

import Foundation
import Moya

final class DotchiMoyaProvider<TargetRouter: TargetType>: MoyaProvider<TargetRouter> {
    convenience init(isLoggingOn: Bool = false) {
        self.init(plugins: [NetworkLoggerPlugin()])
    }
}
