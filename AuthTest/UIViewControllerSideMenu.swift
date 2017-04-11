//
//  UIViewControllerSideMenu.swift
//  AuthTest
//
//  Created by Wane Wang on 4/12/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift
extension UIViewController {
    
    func setNavigationBarItem() {
        self.addLeftBarButtonWithImage(UIImage(named: "hamburger")!)
        self.slideMenuController()?.removeLeftGestures()
        self.slideMenuController()?.addLeftGestures()
    }
    
    func removeNavigationBarItem() {
        self.navigationItem.leftBarButtonItem = nil
        self.slideMenuController()?.removeLeftGestures()
    }
}
