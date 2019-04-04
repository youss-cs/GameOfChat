//
//  LoginVC.swift
//  GameOfChat
//
//  Created by YouSS on 4/4/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    let profileImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "gameofthrones_splash")
        img.contentMode = .scaleAspectFit
        return img
    }()
    
    let segmente: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Login", "Register"])
        seg.selectedSegmentIndex = 0
        seg.tintColor = .white
        return seg
    }()
    
    let contentView: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.layer.cornerRadius = 5
        view.layer.masksToBounds = true
        return view
    }()
    
    let usernameField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Name"
        tf.autocapitalizationType = .words
        return tf
    }()
    
    let usernameSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(220, 220, 220)
        return view
    }()
    
    let emailField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Email"
        tf.keyboardType = UIKeyboardType.emailAddress
        tf.autocapitalizationType = .none
        return tf
    }()
    
    let emailSeparator : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(220, 220, 220)
        return view
    }()
    
    let passwordField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        return tf
    }()
    
    let loginRegisterButton: UIButton = {
        let btn = UIButton()
        btn.backgroundColor = UIColor.rgb(80, 101, 161)
        btn.setTitle("Register", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(handleRegister), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleRegister() {
        guard let email = emailField.text?.lowercased(), email.count > 0 else { return }
        guard let password = passwordField.text, password.count > 0 else { return }
        guard let username = usernameField.text, username.count > 0 else { return }
        
        AuthService.instance.registerUserWith(email: email, password: password, username: username, image: profileImg.image) { (res) in
            switch res {
            case .failure(let error) :
                print(error.localizedDescription)
            case .success(_) :
                self.present(LoginVC(), animated: true, completion: nil)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.rgb(61, 91, 151)
        
        //profileImg.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImg.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        segmente.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(usernameField)
        contentView.addSubview(usernameSeparator)
        contentView.addSubview(emailField)
        contentView.addSubview(emailSeparator)
        contentView.addSubview(passwordField)
        view.addSubview(contentView)
        
        contentView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        usernameField.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), size: CGSize(width: 0, height: 50))
        usernameSeparator.anchor(top: usernameField.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, size: CGSize(width: 0, height: 1))
        emailField.anchor(top: usernameSeparator.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), size: CGSize(width: 0, height: 50))
        emailSeparator.anchor(top: emailField.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, size: CGSize(width: 0, height: 1))
        passwordField.anchor(top: emailSeparator.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12), size: CGSize(width: 0, height: 50))
        
        
        let stack = UIStackView(arrangedSubviews: [profileImg,segmente,contentView,loginRegisterButton])
        stack.distribution = .equalSpacing
        stack.spacing = 15
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}
