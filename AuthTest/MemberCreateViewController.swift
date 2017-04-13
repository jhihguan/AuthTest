//
//  MemberCreateViewController.swift
//  AuthTest
//
//  Created by Wane Wang on 4/12/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

class MemberCreateViewController: UIViewController, AlertShowable {

    @IBOutlet weak var nameTextField: UITextField!
    private let provider: NetworkProvider
    
    init(_ provider: NetworkProvider) {
        self.provider = provider
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
        nameTextField.resignFirstResponder()
        provider.createMember(username: username) { [weak self] (error) in
            if let error = error {
                self?.showAlert(error.message)
            } else {
                self?.nameTextField.text = ""
                self?.showAlert("創建\(username)成功")
            }
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
