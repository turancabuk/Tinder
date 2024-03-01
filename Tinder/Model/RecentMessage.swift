//
//  RecentMessage.swift
//  Tinder
//
//  Created by Turan Çabuk on 1.03.2024.
//

import UIKit
import LBTATools
import Firebase


struct RecentMessage {
    let profileImageUrl, name, text, uid: String
    let timeStamp: Timestamp
    
    init(dictionary: [String: Any]) {
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.name = dictionary["name"] as? String ?? ""
        self.text = dictionary["text"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
        self.timeStamp = dictionary["timeStamp"] as? Timestamp ?? Timestamp(date: Date())
    }
}
