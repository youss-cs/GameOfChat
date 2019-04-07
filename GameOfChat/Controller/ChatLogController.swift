//
//  ChatLogController.swift
//  GameOfChat
//
//  Created by YouSS on 4/7/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import Firebase

class ChatLogController: UICollectionViewController {

    var user: User? {
        didSet{
            navigationItem.title = user?.username
        }
    }
    
    lazy var inputTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter message..."
        textField.delegate = self
        return textField
    }()
    
    lazy var sendButton: UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("Send", for: .normal)
        button.addTarget(self, action: #selector(handleSend), for: .touchUpInside)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView?.backgroundColor = UIColor.white
        
        setupInputComponents()
    }
    
    func setupInputComponents() {
        let containerView = UIView()
        containerView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(containerView)
        
        containerView.anchor(top: nil, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor, size: CGSize(width: 0, height: 50))
        
        containerView.addSubview(sendButton)
        containerView.addSubview(inputTextField)
        
        sendButton.anchor(top: containerView.topAnchor, leading: nil, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, trailing: containerView.trailingAnchor, size: CGSize(width: 80, height: 0))
        
        inputTextField.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: containerView.safeAreaLayoutGuide.bottomAnchor, trailing: sendButton.leadingAnchor, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
        
        let separatorLineView = UIView()
        separatorLineView.backgroundColor = UIColor.rgb(220, 220, 220)
        containerView.addSubview(separatorLineView)
        
        separatorLineView.anchor(top: containerView.topAnchor, leading: containerView.leadingAnchor, bottom: nil, trailing: containerView.trailingAnchor, size: CGSize(width: 0, height: 1))
    }
    
    @objc func handleSend() {
        guard let fromId = AuthService.instance.currentUser()?.id else { return }
        guard let toId = user?.id else { return }
        guard let text = inputTextField.text else { return }
        
        let dict: [String : Any] = [
            kTEXT: text,
            kTOID: toId,
            kFROMID: fromId,
            kSENTDATE: Timestamp(date: Date())
        ]
        
        guard let message = Message(dictionary: dict) else { return }
        
        MessageService.shared.addMessage(message: message)
    }
}

extension ChatLogController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}
