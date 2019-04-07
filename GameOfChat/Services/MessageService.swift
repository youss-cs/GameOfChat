//
//  MessageService.swift
//  GameOfChat
//
//  Created by YouSS on 4/7/19.
//  Copyright © 2019 YouSS. All rights reserved.
//

import Foundation

import Firebase

class MessageService {
    
    static let shared = MessageService()
    
    func addMessage(message: Message, completion: ((_ result: Result<Bool,Error>) -> Void)? = nil) {
        reference(.Messages).addDocument(data: message.dictionary) { (error) in
            if let err = error {
                completion?(.failure(err))
                return
            }
            completion?(.success(true))
        }
    }
}
