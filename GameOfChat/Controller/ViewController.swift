//
//  ViewController.swift
//  GameOfChat
//
//  Created by YouSS on 4/4/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        setupView()
        setupNavButtons()
    }
    
    func setupView() {
        self.view.backgroundColor = .white
        self.title = "Login"
    }
    
    func setupNavButtons() {
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "LogOut", style: .plain, target: self, action: #selector(handleLogOut))
    }

    @objc func handleLogOut() {
        self.present(LoginVC(), animated: true, completion: nil)
    }

}

