//
//  UserCell.swift
//  GameOfChat
//
//  Created by YouSS on 4/5/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit
import SDWebImage

class UserCell: UITableViewCell {
    
    var user: User? {
        didSet{
            guard let user = user else { return }
            profileImageView.sd_setImage(with: URL(string: user.profileImage))
            txtLabel.text = user.username
            detailTxtLabel.text = user.email
        }
    }
    
    var message: Message? {
        didSet{
            guard let message = message else { return }
            guard let partnerId = message.chatPartnerId else { return }
            
            detailTxtLabel.text = message.text
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "hh:mm:ss a"
            timeLabel.text = dateFormatter.string(from: message.sentDate)
            
            UserService.shared.fetchUser(userId: partnerId) { (user) in
                self.profileImageView.sd_setImage(with: URL(string: user.profileImage))
                self.txtLabel.text = user.username
            }
        }
    }
    
    let profileImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()
    
    let txtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.boldSystemFont(ofSize: 14)
        return label
    }()
    
    let detailTxtLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        return label
    }()
    
    let timeLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.systemFont(ofSize: 12)
        label.textColor = UIColor.darkGray
        return label
    }()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        setupView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupView() {
        addSubview(profileImageView)
        addSubview(txtLabel)
        addSubview(detailTxtLabel)
        addSubview(timeLabel)
        
        profileImageView.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: nil, padding: UIEdgeInsets(top: 0, left: 8, bottom: 0, right: 0), size: CGSize(width: 50, height: 50))
        profileImageView.layer.cornerRadius = 50 / 2
        profileImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        
        txtLabel.anchor(top: profileImageView.topAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 8))
        detailTxtLabel.anchor(top: txtLabel.bottomAnchor, leading: profileImageView.trailingAnchor, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 8, bottom: 0, right: 8))
        timeLabel.anchor(top: profileImageView.topAnchor, leading: nil, bottom: nil, trailing: trailingAnchor, padding: UIEdgeInsets(top: 5, left: 0, bottom: 0, right: 0), size: CGSize(width: 100, height: 0))
    }
}
