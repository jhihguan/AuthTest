//
//  ViewController.swift
//  AuthTest
//
//  Created by Wane Wang on 4/11/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

class ViewController: UIViewController, AlertShowable {

    @IBOutlet weak var accountTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    private let session = URLSession.shared
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
            session.dataTask(with: request, completionHandler: { [weak self] (data, response, error) in
                if let error = error {
                    print(error)
                    self?.showAlert("網路錯誤")
                    return
                }
                let httpResponse = response as! HTTPURLResponse
                guard 200 ..< 300 ~= httpResponse.statusCode else {
                    self?.showAlert("伺服器錯誤")
                    return
                }
                guard let data = data else {
                    self?.showAlert("資料錯誤")
                    return
                }
                do {
                    let responseDictionary = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as? [String: Any]
                    guard let dict = responseDictionary?["token"] as? [String: Any] else {
                        self?.showAlert("回傳格式錯誤")
                        return
                    }
                    let session = UserSession.init(dict)
                    print(session)
                } catch {
                    self?.showAlert("回傳格式錯誤")
                }
            }).resume()
            
        } catch {
            showAlert("處理參數錯誤")
        }
    }

}

