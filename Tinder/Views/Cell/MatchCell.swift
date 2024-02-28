//
//  MatchCell.swift
//  Tinder
//
//  Created by Turan Çabuk on 28.02.2024.
//

import UIKit
import LBTATools

class MatchCell: LBTAListCell<Match> {
    
    let profileImageView = UIImageView(image: #imageLiteral(resourceName: "fred"), contentMode: .scaleAspectFit)
    let userNameLabel = UILabel(text: "User Name Here", font: .systemFont(ofSize: 14, weight: .semibold))
    
    override var item: Match! {
        didSet {
            userNameLabel.text = item.name
            profileImageView.sd_setImage(with: URL(string: item.profileImageUrl))
        }
    }
    
    override func setupViews() {
        
        profileImageView.clipsToBounds = true
        profileImageView.constrainWidth(80)
        profileImageView.constrainHeight(80)
        profileImageView.layer.cornerRadius = 80 / 2
        profileImageView.contentMode = .scaleAspectFill
        userNameLabel.textAlignment = .center
        stack(stack(profileImageView, alignment: .center), userNameLabel)
    }
}
