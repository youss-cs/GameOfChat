//
//  ViewController.swift
//  GameOfChat
//
//  Created by YouSS on 4/4/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit

class HomeVC: UIViewController {

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
    }
    
    func checkLoginUser() {
        if AuthService.instance.currentUser() == nil {
            self.present(LoginVC(), animated: true)
        }
    }

    @objc func handleLogOut() {
        AuthService.instance.logOutCurrentUser { (result) in
            switch result {
            case .success(_):
                self.present(LoginVC(), animated: true)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}

