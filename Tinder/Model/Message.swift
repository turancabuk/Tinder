//
//  Message.swift
//  Tinder
//
//  Created by Turan Çabuk on 28.02.2024.
//

import Firebase

struct Message {
    let text, fromId, toId: String
    let timeStmap: Timestamp
    let isFromCurrentUser: Bool
    
    init(dictionary: [String: Any]) {
        self.text = dictionary["text"] as? String ?? ""
        self.fromId = dictionary["fromId"] as? String ?? ""
        self.toId = dictionary["toId"] as? String ?? ""
        self.timeStmap = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
        self.isFromCurrentUser = Auth.auth().currentUser?.uid == self.fromId
    }
}
