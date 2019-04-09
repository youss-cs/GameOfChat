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
            observeMessages()
        }
    }
    
    lazy var containerView: ChatInputAccessoryView = {
        let frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
        let chatInputAccessoryView = ChatInputAccessoryView(frame: frame)
        chatInputAccessoryView.delegate = self
        return chatInputAccessoryView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.contentInset = UIEdgeInsets(top: 8, left: 0, bottom: 8, right: 0)
        collectionView.alwaysBounceVertical = true
        collectionView.backgroundColor = UIColor.white
        collectionView.keyboardDismissMode = .interactive
        collectionView.register(ChatMessageCell.self, forCellWithReuseIdentifier: cellId)
    }
    
    func observeMessages(){
        guard let currentId = AuthService.shared.currentUser()?.id else { return }
        guard let userId = user?.id else { return }
        let converId = getConversationId(uid1: currentId, uid2: userId)
        reference(.Conversation).document(converId).collection("Messages").order(by: kSENTDATE).addSnapshotListener { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            
            snapshot.documentChanges.forEach({ (change) in
                self.handleDocumentChange(change)
            })
        }
    }
    
    func handleDocumentChange(_ change: DocumentChange) {
        let document = change.document
        guard let message = Message(dictionary: document.dataWithId()) else { return }
        
        switch change.type {
        case .added:
            messages.append(message)
            let indexPath = IndexPath(row: messages.count - 1, section: 0)
            collectionView.insertItems(at: [indexPath])
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

extension ChatLogController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let text = messages[indexPath.item].text
        let height = text.estimateFrameForText(fontSize: 16).height + 20
        return CGSize(width: view.frame.width, height: height)
    }
}

extension ChatLogController: ChatInputAccessoryViewDelegate {
    override var inputAccessoryView: UIView? {
        get { return containerView }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
    }
    
    func didSend(for text: String) {
        guard let fromId = AuthService.shared.currentUser()?.id else { return }
        guard let toId = user?.id else { return }
        
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
                self.containerView.clearChatTextField()
            case .failure(let error):
                print(error)
            }
        }
    }
}

