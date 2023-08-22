//
//  GamMoyaProvider.swift
//  GAM
//
//  Created by Jungbin on 2023/08/23.
//

import Foundation
import Moya

final class GamMoyaProvider<TargetRouter: TargetType>: MoyaProvider<TargetRouter> {
    convenience init(isLoggingOn: Bool = false) {
        self.init(plugins: [NetworkLoggerPlugin()])
    }
}
