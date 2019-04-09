//
//  HelperFunctions.swift
//  GameOfChat
//
//  Created by YouSS on 4/9/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation

public func getConversationId(uid1: String, uid2: String) -> String{
    return uid1 < uid2 ? uid1 + uid2 : uid2 + uid1
}
