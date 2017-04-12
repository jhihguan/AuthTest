//
//  UserDefaultsExtension.swift
//  AuthTest
//
//  Created by Wane Wang on 4/13/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import Foundation

extension UserDefaults {
    func set(_ value: Any?, type: UserData) {
        self.set(value, forKey: type.rawValue)
    }
    
    func get(type: UserData) -> Any? {
        return self.value(forKey: type.rawValue)
    }
    
    func string(type: UserData) -> String? {
        return self.string(forKey: type.rawValue)
    }
}
