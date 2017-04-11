//
//  AlertShowable.swift
//  AuthTest
//
//  Created by Wane Wang on 4/11/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

protocol AlertShowable {
    func showAlert(_ message: String)
}

extension AlertShowable where Self: UIViewController {
    
    func showAlert(_ message: String) {
        let alert = UIAlertController(title: nil, message: message, preferredStyle: .alert)
        let okAction = UIAlertAction(title: "確定", style: .default, handler: nil)
        alert.addAction(okAction)
        self.present(alert, animated: true, completion: {
        })
    }
}
