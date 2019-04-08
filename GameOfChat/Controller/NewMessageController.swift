//
//  NewMessageController.swift
//  GameOfChat
//
//  Created by YouSS on 4/5/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit

class NewMessageController: UITableViewController {
    
    var messagesController: MessagesController?
    var users = [User]()

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBar()
        setupView()
        fetchUsers()
    }
    
    fileprivate func setupView() {
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        tableView.tableFooterView = UIView()
    }
    
    fileprivate func setupNavigationBar() {
        navigationItem.title = "New Message"
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
    }
    
    @objc func handleCancel() {
        dismiss(animated: true)
    }
    
    func fetchUsers() {
        UserService.shared.fetchUsers { (users) in
            self.users = users
            self.tableView.reloadData()
        }
    }

}


extension NewMessageController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let user = users[indexPath.row]
        dismiss(animated: true) {
            self.messagesController?.showChatController(user: user)
        }
    }
}
