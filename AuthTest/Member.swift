//
//  Member.swift
//  AuthTest
//
//  Created by Wane Wang on 4/11/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation

struct Member {
    let id: Int
    let name: String
    
    init?(_ dictionary: [String: Any]) {
        guard let idNumber = dictionary["ID"] as? Int,
            let nameString = dictionary["name"] as? String else {
                return nil
        }
        id = idNumber
        name = nameString
    }
}
