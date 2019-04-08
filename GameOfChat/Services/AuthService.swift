//
//  AuthService.swift
//  Swiford
//
//  Created by OuSS on 10/31/18.
//  Copyright © 2018 OuSS. All rights reserved.
//

import Foundation
import Firebase

class AuthService {
    
    static let shared = AuthService()
    
    //MARK: Returning current user funcs
    
    func currentUser() -> User? {
        if Auth.auth().currentUser != nil {
            if let dictionary = UserDefaults.standard.object(forKey: kCURRENTUSER) as? [String : Any] {
                return User(dictionary: dictionary)
            }
        }
        return nil
    }
    
    //MARK: Login function
    
    func loginUserWith(email: String, password: String, completion: @escaping (Result<Bool,Error>) -> Void) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (firUser, error) in
            
            if let error = error {
                completion(.failure(error))
                return
            }
            
            //get user from firebase and save locally
            UserService.shared.fetchUser(userId: firUser!.user.uid, completion: { (user) in
                self.saveUserLocally(user: user)
                completion(.success(true))
            })
            
        })
    }
    
    //MARK: Register functions
    
    func registerUserWith(email: String, password: String, username: String, image: UIImage?, completion: @escaping (Result<Bool,Error>) -> Void ) {
        
        Auth.auth().createUser(withEmail: email, password: password, completion: { (result, error) in
            if let error = error {
                completion(.failure(error))
                return
            }
            
            guard let fuser = result?.user else {
                completion(.failure(AuthError.noUser))
                return
            }
            
            //let token = Messaging.messaging().fcmToken ?? ""
            var dict: [String : Any] = [kID : fuser.uid, kEMAIL : fuser.email!, kUSERNAME : username]
            
            guard let image = image else {
                self.saveUser(dictionary: dict)
                completion(.success(true))
                return
            }
            
            StorageService.shared.uploadImage(image: image, path: kPROFILE, completion: { (result) in
                switch result {
                case .success(let avatar):
                    dict[kPROFILEIMAGEURL] = avatar
                    self.saveUser(dictionary: dict)
                    completion(.success(true))
                case .failure(let error):
                    completion(.failure(error))
                }
            })
        })
    }
    
    //MARK: LogOut func
    
     func logOutCurrentUser(completion: @escaping (Result<Bool,Error>) -> Void) {
        userDefaults.removeObject(forKey: kCURRENTUSER)
        userDefaults.synchronize()
        
        do {
            try Auth.auth().signOut()
            completion(.success(true))
        } catch let error {
            completion(.failure(error))
        }
    }
    
    //MARK: Delete user
    
    func deleteUser(completion: @escaping (_ error: Error?) -> Void) {
        let user = Auth.auth().currentUser
        user?.delete(completion: { (error) in
            completion(error)
        })
    }
    
    //MARK: Save user funcs
    
    func saveUserToFirestore(user: User) {
        reference(.Users).document(user.id).setData(user.dictionary) { (error) in
            print("error is \(String(describing: error?.localizedDescription))")
        }
    }
    
    func saveUserLocally(user: User) {
        UserDefaults.standard.set(user.dictionary, forKey: kCURRENTUSER)
        UserDefaults.standard.synchronize()
    }
    
    func saveUser(dictionary:[String : Any]) {
        let user = User(dictionary: dictionary)
        self.saveUserToFirestore(user: user)
        self.saveUserLocally(user: user)
    }
    
    
}
