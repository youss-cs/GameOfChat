//
//  MessagesController.swift
//  GameOfChat
//
//  Created by YouSS on 4/4/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit

class MessagesController: UITableViewController {

    var messages = [Message]()
    var messagesDict = [String : Message]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        setupNavButtons()
        checkLoginUser()
        observeMessages()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.title = "Login"
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    func observeMessages() {
        reference(.Messages).order(by: kSENTDATE).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documents.forEach({ (snapshot) in
                guard let message = Message(dictionary: snapshot.dataWithId()) else { return }
                self.messagesDict[message.toId] = message
                self.messages = Array(self.messagesDict.values)
                self.messages.sort(by: { (msg1, msg2) -> Bool in
                    return msg1.sentDate.compare(msg2.sentDate) == .orderedDescending
                })
                self.tableView.reloadData()
            })
            
        }
    }
    
    func setupNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    func showChatController(user: User) {
        let chatLogController = ChatLogController(collectionViewLayout: UICollectionViewFlowLayout())
        chatLogController.user = user
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    
    func checkLoginUser() {
        if let user = AuthService.instance.currentUser() {
            self.title = user.username
        } else {
            UIApplication.setRootView(LoginController())
        }
    }
    
    @objc func handleNewMessage() {
        let newMessageController = NewMessageController()
        newMessageController.messagesController = self
        let navController = UINavigationController(rootViewController: newMessageController)
        present(navController, animated: true)
    }

    @objc func handleLogOut() {
        AuthService.instance.logOutCurrentUser { (result) in
            switch result {
            case .success(_):
                UIApplication.setRootView(LoginController())
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

extension MessagesController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 72
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.message = messages[indexPath.row]
        return cell
    }
}

