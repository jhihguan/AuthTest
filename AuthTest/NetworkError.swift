//
//  NetworkErr.swift
//  AuthTest
//
//  Created by Wane Wang on 4/11/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation

enum NetworkError: Error {
    case serverError
    case urlError
    case responseError
    case parameterError
    
    var message: String {
        switch self {
        case .serverError:
            return "伺服器錯誤"
        case .urlError:
            return "連結錯誤"
        case .responseError:
            return "回應格式錯誤"
        case .parameterError:
            return "參數錯誤"
        }
    }
}
