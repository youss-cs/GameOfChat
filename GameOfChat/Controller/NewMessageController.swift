//
//  NewMessageController.swift
//  GameOfChat
//
//  Created by YouSS on 4/5/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import Firebase

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
    
    func fetchUsers(){
        reference(.Users).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documentChanges.forEach({ (change) in
                self.handleDocumentChange(change)
            })
        }
    }
    
    func handleDocumentChange(_ change: DocumentChange) {
        let user = User(dictionary: change.document.dataWithId())
        switch change.type {
        case .added:
            users.append(user)
            let indexPath = IndexPath(row: users.count - 1, section: 0)
            tableView.insertRows(at: [indexPath], with: .none)
        default: break
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
