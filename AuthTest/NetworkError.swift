//
//  NetworkErr.swift
//  AuthTest
//
//  Created by Wane Wang on 4/11/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case server
    case status(status: Int)
    case url
    case response
    case parameter
    case token
    case custom(message: String)
    
    var message: String {
        switch self {
        case .server:
            return "伺服器錯誤"
        case .status:
            return "錯誤"
        case .url:
            return "連結錯誤"
        case .response:
            return "回應格式錯誤"
        case .parameter:
            return "參數錯誤"
        case .token:
            return "驗證錯誤"
        case .custom(let message):
            return message
        }
    }
}
