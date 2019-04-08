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

    var messages = [Message]()
    
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

        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 58, right: 0)
        collectionView.scrollIndicatorInsets = UIEdgeInsets(top: 0, left: 0, bottom: 50, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
        
        setupInputComponents()
        observeMessages()
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
        guard let fromId = AuthService.shared.currentUser()?.id else { return }
        guard let toId = user?.id else { return }
        guard let text = inputTextField.text else { return }
        
        let dict: [String : Any] = [
            kTEXT: text,
            kTOID: toId,
            kFROMID: fromId,
            kSENTDATE: Timestamp(date: Date())
        ]
        
        guard let message = Message(dictionary: dict) else { return }
        
        MessageService.shared.addMessage(message: message) { (result) in
            switch result {
            case .success(_):
                self.inputTextField.text = ""
            case .failure(let error):
                print(error)
            }
        }
    }
    
    func observeMessages(){
        guard let userId = AuthService.shared.currentUser()?.id else { return }
        reference(.Chats).document(userId).collection("Messages").addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documentChanges.forEach({ (change) in
                self.handleDocumentChange(change)
            })
        }
        reference(.Users).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documentChanges.forEach({ (change) in
                self.handleDocumentChange(change)
            })
        }
    }
    
    func handleDocumentChange(_ change: DocumentChange) {
        switch change.type {
        case .added:
            MessageService.shared.fetchMessage(messageId: change.document.documentID, completion: { (result) in
                switch result {
                case .success(let message):
                    if message.chatPartnerId == self.user?.id {
                        self.messages.append(message)
                        self.collectionView.reloadData()
                    }
                case .failure(let error):
                    print(error)
                }
            })
        default: break
        }
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        collectionView?.collectionViewLayout.invalidateLayout()
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellId, for: indexPath) as! ChatMessageCell
        
        cell.message = messages[indexPath.item]
        if let profileImageURL = self.user?.profileImage {
            cell.profileImageView.sd_setImage(with: URL(string: profileImageURL))
        }
        return cell
    }
}

extension ChatLogController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        handleSend()
        return true
    }
}

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = messages[indexPath.item].text
        let height = text.estimateFrameForText(fontSize: 16).height + 20
        return CGSize(width: view.frame.width, height: height)
    }
}

