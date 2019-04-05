//
//  ViewController.swift
//  GameOfChat
//
//  Created by YouSS on 4/4/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit

class MessagesVC: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        setupNavButtons()
        checkLoginUser()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.title = "Login"
    }
    
    func setupNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: #imageLiteral(resourceName: "new_message_icon"), style: .plain, target: self, action: #selector(handleNewMessage))
    }
    
    func checkLoginUser() {
        if let user = AuthService.instance.currentUser() {
            self.title = user.username
        } else {
            self.present(LoginVC(), animated: true)
        }
    }
    
    @objc func handleNewMessage() {
        let nav = UINavigationController(rootViewController: MessageVC())
        present(nav, animated: true)
    }

    @objc func handleLogOut() {
        AuthService.instance.logOutCurrentUser { (result) in
            switch result {
            case .success(_):
                UIApplication.setRootView(LoginVC())
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

