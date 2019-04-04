//
//  QueryDocumentSnapshot.swift
//  InstaFirebase
//
//  Created by YouSS on 12/11/18.
//  Copyright © 2018 YouSS. All rights reserved.
//

import Firebase

extension QueryDocumentSnapshot {
    func dataWithId() -> [String : Any] {
        var documetData = data()
        documetData[kID] = documentID
        return documetData
    }
}
