//
//  LoginVC.swift
//  GameOfChat
//
//  Created by YouSS on 4/4/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {
    
    var contentViewHeight: NSLayoutConstraint?
    var usernameFieldHeight: NSLayoutConstraint?
    var emailFieldHeight: NSLayoutConstraint?
    var passwordFieldHeight: NSLayoutConstraint?
    
    lazy var profileImg: UIImageView = {
        let img = UIImageView()
        img.image = UIImage(named: "gameofthrones_splash")
        img.contentMode = .scaleAspectFit
        img.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTapProfileImg)))
        img.isUserInteractionEnabled = true
        return img
    }()
    
    lazy var loginRegisterSegmentedControl: UISegmentedControl = {
        let seg = UISegmentedControl(items: ["Login", "Register"])
        seg.selectedSegmentIndex = 1
        seg.tintColor = .white
        seg.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        return seg
    }()
    
    @objc func handleTapProfileImg() {
        let imgPicker = UIImagePickerController()
        imgPicker.delegate = self
        imgPicker.allowsEditing = true
        present(imgPicker, animated: true)
    }
    
    @objc func handleLoginRegisterChange() {
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: UIControl.State())
        
        contentViewHeight?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        usernameFieldHeight?.isActive = false
        usernameFieldHeight = usernameField.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1/3)
        usernameFieldHeight?.isActive = true
        usernameField.isHidden = loginRegisterSegmentedControl.selectedSegmentIndex == 0
        
        emailFieldHeight?.isActive = false
        emailFieldHeight = emailField.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        emailFieldHeight?.isActive = true
        
        passwordFieldHeight?.isActive = false
        passwordFieldHeight = passwordField.heightAnchor.constraint(equalTo: contentView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1/2 : 1/3)
        passwordFieldHeight?.isActive = true
    }
    
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
        btn.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        return btn
    }()
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        } else {
            handleRegister()
        }
    }
    
    func handleLogin() {
        guard let email = emailField.text, let password = passwordField.text else { return }
        
        AuthService.instance.loginUserWith(email: email, password: password) { (result) in
            switch result {
            case .success(_):
                self.presentMessageVC()
            case .failure(let error):
                print(error)
            }
        }
    }
    
    
    
    @objc func handleRegister() {
        guard let email = emailField.text?.lowercased(), email.count > 0 else { return }
        guard let password = passwordField.text, password.count > 0 else { return }
        guard let username = usernameField.text, username.count > 0 else { return }
        
        AuthService.instance.registerUserWith(email: email, password: password, username: username, image: profileImg.image) { (res) in
            switch res {
            case .success(_) :
                self.presentMessageVC()
            case .failure(let error) :
                print(error.localizedDescription)
            }
        }
    }
    
    func presentMessageVC() {
        let nav = UINavigationController(rootViewController: MessagesVC())
        UIApplication.setRootView(nav)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        
        setupView()
    }
    
    func setupView() {
        view.backgroundColor = UIColor.rgb(61, 91, 151)
        
        profileImg.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 30).isActive = true
        
        contentView.addSubview(usernameField)
        contentView.addSubview(usernameSeparator)
        contentView.addSubview(emailField)
        contentView.addSubview(emailSeparator)
        contentView.addSubview(passwordField)
        view.addSubview(contentView)
        
        contentViewHeight = contentView.heightAnchor.constraint(equalToConstant: 150)
        contentViewHeight?.isActive = true
        
        usernameField.anchor(top: contentView.topAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        usernameFieldHeight = usernameField.heightAnchor.constraint(equalToConstant: 50)
        usernameFieldHeight?.isActive = true
        
        usernameSeparator.anchor(top: usernameField.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, size: CGSize(width: 0, height: 1))
        
        emailField.anchor(top: usernameSeparator.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        emailFieldHeight = emailField.heightAnchor.constraint(equalToConstant: 50)
        emailFieldHeight?.isActive = true
        
        emailSeparator.anchor(top: emailField.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, size: CGSize(width: 0, height: 1))
        
        passwordField.anchor(top: emailSeparator.bottomAnchor, leading: contentView.leadingAnchor, bottom: nil, trailing: contentView.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        passwordFieldHeight = passwordField.heightAnchor.constraint(equalToConstant: 50)
        passwordFieldHeight?.isActive = true
        
        
        let stack = UIStackView(arrangedSubviews: [profileImg,loginRegisterSegmentedControl,contentView,loginRegisterButton])
        stack.distribution = .equalSpacing
        stack.spacing = 15
        stack.axis = .vertical
        
        view.addSubview(stack)
        stack.anchor(top: nil, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, padding: UIEdgeInsets(top: 0, left: 12, bottom: 0, right: 12))
        stack.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
    }

}

extension LoginVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        var selectedImg: UIImage?
        
        if let editedImg = info[.editedImage] as? UIImage {
            selectedImg = editedImg
        } else if let originalImg = info[.originalImage] as? UIImage  {
            selectedImg = originalImg
        }
        
        profileImg.image = selectedImg
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}
