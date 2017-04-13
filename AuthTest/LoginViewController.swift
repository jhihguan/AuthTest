//
//  LoginViewController.swift
//  AuthTest
//
//  Created by Wane Wang on 4/12/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, AlertShowable {
    
    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private let provider: NetworkProvider
    
    init(_ provider: NetworkProvider) {
        self.provider = provider
        super.init(nibName: "\(LoginViewController.self)", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func loginAction(_ sender: Any) {
        guard let account = accountTextField.text,
            let password = passwordTextField.text,
            !account.isEmpty, !password.isEmpty else {
                showAlert("請輸入帳號及密碼")
                return
        }
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        provider.login(account: account, password: password) { [weak self] (error) in
            if let error = error {
                self?.showAlert(error.message)
            } else {
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    self?.showAlert("發生不可能錯誤\n請重試！")
                    return
                }
                appDelegate.loginSuccess()
            }
            
        }
    }

}
