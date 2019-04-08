//
//  ChatMessageCell.swift
//  GameOfChat
//
//  Created by YouSS on 4/8/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation
import UIKit

class ChatMessageCell: UICollectionViewCell {
    
    var message: Message? {
        didSet{
            guard let text = message?.text else { return }
            guard let currentUserId = AuthService.shared.currentUser()?.id else { return }
            
            textView.text = text
            bubbleWidthAnchor?.constant = text.estimateFrameForText(fontSize: 16).width + 30
            
            if message?.fromId == currentUserId {
                //outgoing blue
                bubbleView.backgroundColor = UIColor.blueColor
                textView.textColor = UIColor.white
                profileImageView.isHidden = true
                
                bubbleViewTrailingAnchor?.isActive = true
                bubbleViewLeadingAnchor?.isActive = false
                
            } else {
                //incoming gray
                bubbleView.backgroundColor = UIColor.rgb(240, 240, 240)
                textView.textColor = UIColor.black
                profileImageView.isHidden = false
                
                bubbleViewTrailingAnchor?.isActive = false
                bubbleViewLeadingAnchor?.isActive = true
            }
        }
    }
    
    var bubbleWidthAnchor: NSLayoutConstraint?
    var bubbleViewTrailingAnchor: NSLayoutConstraint?
    var bubbleViewLeadingAnchor: NSLayoutConstraint?
    
    let bubbleView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.rgb(0, 137, 249)
        view.layer.cornerRadius = 14
        view.layer.masksToBounds = true
        return view
    }()
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.font = UIFont.systemFont(ofSize: 16)
        tv.backgroundColor = .clear
        tv.textColor = .white
        return tv
    }()
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.layer.cornerRadius = 16
        imageView.layer.masksToBounds = true
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addSubview(bubbleView)
        addSubview(profileImageView)
        bubbleView.addSubview(textView)
        
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: nil, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 32, height: 32))
        
        
        
        bubbleView.anchor(top: topAnchor, leading: nil, bottom: bottomAnchor, trailing: nil)
        
        bubbleViewTrailingAnchor = bubbleView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -8)
        bubbleViewTrailingAnchor?.isActive = true
        bubbleViewLeadingAnchor = bubbleView.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 8)
        bubbleWidthAnchor = bubbleView.widthAnchor.constraint(equalToConstant: 200)
        bubbleWidthAnchor?.isActive = true
        
        textView.fillSuperview(padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0))
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
