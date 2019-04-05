//
//  UserCell.swift
//  GameOfChat
//
//  Created by YouSS on 4/5/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import UIKit

class UserCell: UITableViewCell {
    
    var user: User? {
        didSet {
            //
        }
    }

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
