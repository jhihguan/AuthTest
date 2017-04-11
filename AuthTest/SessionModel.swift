//
//  SessionModel.swift
//  AuthTest
//
//  Created by Wane Wang on 4/11/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation

struct UserSession {
    let expTime: Date
    let token: String
    
    init?(_ dictionary: [String: Any]) {
        guard let expNumber = dictionary["exp"] as? Int,
            let tokenString = dictionary["token"] as? String else {
            return nil
        }
        expTime = Date.init(timeIntervalSince1970: TimeInterval(expNumber))
        token = tokenString
    }
}
