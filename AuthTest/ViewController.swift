//
//  ViewController.swift
//  AuthTest
//
//  Created by Wane Wang on 4/11/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

class ViewController: UIViewController, NetworkRequestable, AlertShowable {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
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
            let password = passwordTextField.text else {
                showAlert("請輸入帳號及密碼")
                return
        }
        accountTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
        guard let url = URL(string: "http://52.197.192.141:3443") else {
            showAlert("發生錯誤")
            return
        }
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONSerialization.data(withJSONObject: ["name": account, "pwd": password], options: .init(rawValue: 0))
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            self.request(request, complete: { [weak self] (responseDictionary, error) in
                if let error = error {
                    self?.showAlert(error.message)
                    return
                }
                guard let dict = responseDictionary?["token"] as? [String: Any],
                    let session = UserSession.init(dict) else {
                    self?.showAlert("回傳格式錯誤")
                    return
                }
                let memberListViewController = MemberListViewController(session)
                guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                    return
                }
                appDelegate.updateRootViewController(memberListViewController)
            })
        } catch {
            showAlert("處理參數錯誤")
        }
    }

}

