//
//  User.swift
//  Tinder
//
//  Created by Turan Çabuk on 29.01.2024.
//

import UIKit

struct User: ProducesCardViewModel {

    var name: String?
    var age: Int?
    var profession: String?
    var imageUrl1: String?
    var uid: String?
    
    init(dictionary: [String: Any]) {
        
        self.name = dictionary["fullName"] as? String
        self.age = dictionary["age"] as? Int ?? 0
        self.profession = dictionary["profession"] as? String 
        self.profession = "F1 Lover"
        self.imageUrl1 = dictionary["imageUrl1"] as? String ?? ""
        self.uid = dictionary["uid"] as? String ?? ""
    }
    func toCardViewModel() -> CardViewModel {
        let attributedText = NSMutableAttributedString(string: name ?? "", attributes: [.font: UIFont.systemFont(ofSize: 32, weight: .heavy)])
        attributedText.append(NSAttributedString(string: "  \(age ?? 0)", attributes: [.font: UIFont.systemFont(ofSize: 24, weight: .regular)]))
        
        attributedText.append(NSAttributedString(string: "\n\(profession ?? "")", attributes: [.font: UIFont.systemFont(ofSize: 20, weight: .regular)]))
        
        return CardViewModel(imageNames: [imageUrl1 ?? ""], attributedString: attributedText, textAlignment: .left)
    }
}
