//
//  FCollectionReference.swift
//  WChat
//
//  Created by David Kababyan on 06/05/2018.
//  Copyright © 2018 David Kababyan. All rights reserved.
//

import Foundation
import FirebaseFirestore

enum FCollectionReference: String {
    case Users
    case Conversation
    case LastestMessages
}

func reference(_ collectionReference: FCollectionReference) -> CollectionReference {
    return Firestore.firestore().collection(collectionReference.rawValue)
}

