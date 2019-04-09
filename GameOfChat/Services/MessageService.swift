//
//  MessageService.swift
//  GameOfChat
//
//  Created by YouSS on 4/7/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation
import Firebase

enum MessageError: Error {
    case noMessage
}

class MessageService {
    
    static let shared = MessageService()
    
    func addMessage(message: Message, completion: ((_ result: Result<Bool,Error>) -> Void)? = nil) {
        let converId = getConversationId(uid1: message.fromId, uid2: message.toId)
        reference(.Conversation).document(converId).collection("Messages").addDocument(data: message.dictionary) { (error) in
            if let err = error {
                completion?(.failure(err))
                return
            }
            
            let fromToPath = "\(message.fromId)/Users/\(message.toId)"
            reference(.LastestMessages).document(fromToPath).setData(message.dictionary)
            
            let toFromPath = "\(message.toId)/Users/\(message.fromId)"
            reference(.LastestMessages).document(toFromPath).setData(message.dictionary)
            
            completion?(.success(true))
        }
    }
}
