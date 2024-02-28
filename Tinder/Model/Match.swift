//
//  Match.swift
//  Tinder
//
//  Created by Turan Çabuk on 28.02.2024.
//

import UIKit
import LBTATools

struct Match {
    let name, profileImageUrl, uid: String
    
    init(dictionary: [String: Any]) {
        self.name = dictionary["name"] as? String ?? ""
        self.profileImageUrl = dictionary["profileImageUrl"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
}
