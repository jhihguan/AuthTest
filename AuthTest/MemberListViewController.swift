//
//  MemberListViewController.swift
//  AuthTest
//
//  Created by Wane Wang on 4/11/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

class MemberListViewController: UIViewController, NetworkRequestable, AlertShowable {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = 60
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "memberCell")
        }
    }
    private let session: UserSession
    internal var members: [Member] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(_ session: UserSession) {
        self.session = session
        super.init(nibName: "\(MemberListViewController.self)", bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let refreshControl = UIRefreshControl()
        refreshControl.attributedTitle = NSAttributedString.init(string: "下拉更新")
        refreshControl.addTarget(self, action: #selector(MemberListViewController.loadMember), for: .valueChanged)
        loadMember(refreshControl)
        tableView.addSubview(refreshControl)
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setNavigationBarItem()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func loadMember(_ sender: UIRefreshControl) {
        sender.endRefreshing()
        guard let url = URL(string: "http://52.197.192.141:3443/member") else {
            showAlert("發生錯誤")
            return
        }
        var request = URLRequest(url: url)
        request.httpMethod = "GET"
        request.addValue(session.token, forHTTPHeaderField: "Authorization")
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        self.request(request) { [weak self] (responseDictionary, error) in
            if let error = error {
                self?.showAlert(error.message)
                return
            }
            guard let dict = responseDictionary?["data"] as? [[String: Any]] else {
                    self?.showAlert("回傳格式錯誤")
                    return
            }
            self?.members = dict.flatMap { Member($0) }
        }
    }

}

extension MemberListViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return members.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "memberCell", for: indexPath)
        let member = members[indexPath.row]
        cell.textLabel?.text = member.name
        return cell
    }
    
    
}

