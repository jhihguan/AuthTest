//
//  SideMenuViewController.swift
//  AuthTest
//
//  Created by Wane Wang on 4/12/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit
import SlideMenuControllerSwift

class SideMenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = 60
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "sideMenuCell")
        }
    }
    let sideMenuDatas = ["取得會員列表", "新增會員", "登出"]
    
    init() {
        super.init(nibName: "\(SideMenuViewController.self)", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sideMenuDatas.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "sideMenuCell", for: indexPath)
        cell.backgroundColor = .clear
        cell.textLabel?.textColor = .white
        let title = sideMenuDatas[indexPath.row]
        cell.textLabel?.text = title
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        switch indexPath.row {
        case 0:
//            sideMenuViewController.changeMainViewController(, close: true)
            break
        case 1:
            break
        case 2:
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            appDelegate.resetToLogin()
        default:
            break
        }
    }

}
