//
//  GamURL.swift
//  GAM
//
//  Created by Jungbin on 2023/08/22.
//

import Foundation

final class GamURL {
    static var shared = GamURL()
    
    init() { }
    
    var url: GamURLEntity = .init(
        intro: "",
        privacyPolicy: "",
        agreement: "",
        makers: ""
    )
}
