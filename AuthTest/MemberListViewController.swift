//
//  MemberListViewController.swift
//  AuthTest
//
//  Created by Wane Wang on 4/11/17.
//  Copyright © 2017 Wane. All rights reserved.
//

import UIKit

class MemberListViewController: UIViewController, AlertShowable {
    
    @IBOutlet weak var tableView: UITableView! {
        didSet {
            tableView.rowHeight = 60
            tableView.register(UITableViewCell.self, forCellReuseIdentifier: "memberCell")
        }
    }
    private let provider: NetworkProvider
    internal var members: [Member] = [] {
        didSet {
            tableView.reloadData()
        }
    }
    
    init(_ provider: NetworkProvider) {
        self.provider = provider
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
        provider.getMembers { [weak self] (members, error) in
            if let error = error {
                self?.showAlert(error.message)
            } else {
                self?.members = members
            }
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
        cell.detailTextLabel?.text = "\(member.id)"
        return cell
    }
    
    
}

