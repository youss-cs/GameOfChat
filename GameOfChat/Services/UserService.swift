//
//  UserService.swift
//  InstaFirebase
//
//  Created by YouSS on 12/12/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import Firebase

class UserService {
    
    static let shared = UserService()
    
    //MARK: Fetch User funcs
    
    func fetchUser(userId: String, completion: @escaping (_ result: Result<User,Error>) -> Void) {
        reference(.Users).document(userId).getDocument { (document, error) in
            if let err = error {
                completion(.failure(err))
                return
            }
            
            guard let document = document, document.exists else { return }
            guard let dictionary = document.data() else { return }
            let user = User(dictionary: dictionary)
            completion(.success(user))
        }
    }
    
    func fetchUsers(completion: @escaping (_ users: [User]) -> Void) {
        guard let loggedUserId = AuthService.shared.currentUser()?.id else { return }
        
        var users = [User]()
        reference(.Users).order(by: "username").getDocuments { (snapshot, error) in
            guard let snapshot = snapshot else { return }
            for document in snapshot.documents {
                if document.documentID != loggedUserId {
                    let user = User(dictionary: document.dataWithId())
                    users.append(user)
                }
            }
            completion(users)
        }
    }
}
