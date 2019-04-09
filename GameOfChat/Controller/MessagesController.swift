//
//  MessagesController.swift
//  GameOfChat
//
//  Created by YouSS on 4/4/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import Firebase

class MessagesController: UITableViewController {

    var messages = [Message]()
    var messagesDict = [String : Message]()
    var timer: Timer?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        setupNavButtons()
        checkLoginUser()
        observeUserMessages()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.title = "Login"
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
    }
    
    func observeUserMessages() {
        guard let userId = AuthService.shared.currentUser()?.id else { return }
        reference(.LastestMessages).document(userId).collection("Users").order(by: kSENTDATE).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documentChanges.forEach({ (change) in
                self.handleDocumentChange(change)
            })
        }
    }
    
    func handleDocumentChange(_ change: DocumentChange) {
        guard let message = Message(dictionary: change.document.dataWithId()) else { return }
        let topIndex = IndexPath(row: 0, section: 0)
        switch change.type {
        case .added:
            messages.insert(message, at: 0)
            tableView.insertRows(at: [topIndex], with: .none)
        case .modified:
            guard let index = messages.firstIndex(where: {$0.chatPartnerId == message.chatPartnerId}) else { return }
            messages[index] = message
            let indexPath = IndexPath(row: index, section: 0)
            let cell = tableView.cellForRow(at: indexPath) as? UserCell
            cell?.timeLabel.text = message.sentDate.string(format:" hh:mm a")
            cell?.detailTxtLabel.text = message.text
            messages.bringToFront(item: message)
            tableView.moveRow(at: indexPath, to: topIndex)
        default: break
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
        if let user = AuthService.shared.currentUser() {
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
        AuthService.shared.logOutCurrentUser { (result) in
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
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let message = messages[indexPath.row]
        guard let partnerId = message.chatPartnerId else { return }
        UserService.shared.fetchUser(userId: partnerId) { (result) in
            switch result {
            case .success(let user):
                self.showChatController(user: user)
            case .failure(let error):
                print(error)
            }
        }
    }
}

