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
        var ref: DocumentReference? = nil
        ref = reference(.Messages).addDocument(data: message.dictionary) { (error) in
            if let err = error {
                completion?(.failure(err))
                return
            }
            
            guard let messageId = ref?.documentID else {
                completion?(.failure(MessageError.noMessage))
                return
            }
            
            reference(.Chats).document("\(message.fromId)/Messages/\(messageId)").setData(["exist" : true])
            reference(.Chats).document("\(message.toId)/Messages/\(messageId)").setData(["exist" : true])
            
            completion?(.success(true))
        }
    }
    
    func fetchMessage(messageId: String, completion: @escaping (_ result: Result<
        Message,Error>) -> Void) {
        reference(.Messages).document(messageId).getDocument { (document, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let document = document, document.exists else { return }
            guard let dictionary = document.data() else { return }
            guard let message = Message(dictionary: dictionary) else { return }
            completion(.success(message))
        }
    }
}
