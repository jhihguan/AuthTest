//
//  MemberCreateViewController.swift
//  AuthTest
//
//  Created by Wane Wang on 4/12/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

class MemberCreateViewController: UIViewController, AlertShowable, NetworkRequestable {

    @IBOutlet weak var nameTextField: UITextField!
    private let session: UserSession
    
    init(_ session: UserSession) {
        self.session = session
        super.init(nibName: "\(MemberCreateViewController.self)", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func createAction(_ sender: Any) {
        guard let username = nameTextField.text,
            !username.isEmpty else {
            showAlert("請輸入名稱")
            return
        }
        guard let url = URL(string: "http://52.197.192.141:3443/member") else {
            showAlert("發生錯誤")
            return
        }
        nameTextField.resignFirstResponder()
        do {
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.httpBody = try JSONSerialization.data(withJSONObject: ["name": username], options: .init(rawValue: 0))
            request.addValue(session.token, forHTTPHeaderField: "Authorization")
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            self.request(request, complete: { [weak self] (responseDictionary, error) in
                if let error = error {
                    self?.showAlert(error.message)
                    return
                }
                guard let code = responseDictionary?["code"] as? String,
                    code == "success" else {
                        self?.showAlert("創建錯誤")
                        return
                }
                self?.showAlert("創建成功")
            })
        } catch {
            showAlert("處理參數錯誤")
        }
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
