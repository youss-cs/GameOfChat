//
//  FCollectionReference.swift
//  WChat
//
//  Created by David Kababyan on 06/05/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import Foundation
import FirebaseFirestore
import FirebaseStorage

enum FCollectionReference: String {
    case Users
    case Posts
    case Following
    case Comments
    case Likes
}

func reference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}

