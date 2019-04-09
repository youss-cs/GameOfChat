//
//  Message.swift
//  GameOfChat
//
//  Created by YouSS on 4/7/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation
import Firebase

class Message {
    
    let id: String?
    var text: String
    var toId: String
    var fromId: String
    var sentDate: Date
    
    var dictionary: [String: Any] {
        return [
            kTEXT: text,
            kTOID: toId,
            kFROMID: fromId,
            kSENTDATE: sentDate
        ]
    }
    
    var chatPartnerId: String? {
        guard let currentId = AuthService.shared.currentUser()?.id else { return nil }
        return fromId == currentId ? toId : fromId
    }
    
    //MARK: Initializers
    
    init?(dictionary: [String : Any]) {
        guard let text = dictionary[kTEXT] as? String,
            let toId = dictionary[kTOID] as? String,
            let fromId = dictionary[kFROMID] as? String,
            let sentDate = dictionary[kSENTDATE] as? Timestamp
            else {
                return nil
        }
        
        id = dictionary[kID] as? String
        self.text = text
        self.toId = toId
        self.fromId = fromId
        self.sentDate = sentDate.dateValue()
    }
}

extension Message: Equatable {
    static func ==(lhs: Message, rhs: Message) -> Bool {
        return lhs.id == rhs.id
    }
}
