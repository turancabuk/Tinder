//
//  RecentMessageCell.swift
//  Tinder
//
//  Created by Turan Çabuk on 1.03.2024.
//

import UIKit
import LBTATools
import Firebase

class RecentMessageCell: LBTAListCell<RecentMessage> {
    
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "fred"), contentMode: .scaleAspectFill)
    let userNameLabel = UILabel(text: "USER NAME", font: .boldSystemFont(ofSize: 18))
    let messageTextLabel = UILabel(text: "2. Sektörde sarı bayraklar var ve Sebastian Vettel bariyerlerde", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    override var item: RecentMessage!{
        didSet{
            userNameLabel.text = item.name
            messageTextLabel.text = item.text
            userProfileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    override func setupViews() {
        
        userProfileImageView.layer.cornerRadius = 90 / 2
        
        hstack(userProfileImageView.withWidth(90).withHeight(90), stack(userNameLabel, messageTextLabel, spacing: 4), spacing: 20, alignment: .center).padLeft(20).padRight(10)
        
        addSeparatorView(leadingAnchor: userNameLabel.leadingAnchor)
    }
}
