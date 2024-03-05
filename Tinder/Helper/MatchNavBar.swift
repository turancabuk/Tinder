//
//  MatchNavBar.swift
//  Tinder
//
//  Created by Turan Çabuk on 26.02.2024.
//

import LBTATools
import UIKit

class MatchNavBar: UIView {
    
    let userProfileImageView = CircularImageView(width: 44, image: #imageLiteral(resourceName: "fred"))
    let userNameLabel = UILabel(text: "USER NAME", font: .systemFont(ofSize: 16))
    let backButton = UIButton(image: #imageLiteral(resourceName: "back"), tintColor: #colorLiteral(red: 0.9860271811, green: 0.3476872146, blue: 0.4476813674, alpha: 1))
    let flagButton = UIButton(image: #imageLiteral(resourceName: "flag"), tintColor: #colorLiteral(red: 0.9860271811, green: 0.3476872146, blue: 0.4476813674, alpha: 1))
    
    fileprivate var match: Match
    
    init(match: Match) {
        self.match = match
        userNameLabel.text = match.name
        userProfileImageView.sd_setImage(with: URL(string: match.profileImageUrl))
        super.init(frame: .zero)
        backgroundColor = .white
        setupShadow(opacity: 0.2, radius: 8, offset: .init(width: 0, height: 10),color: .init(white: 0, alpha: 0.3))
        
        hstack(backButton,
               stack(userProfileImageView, userNameLabel,spacing: 8, alignment: .center),
               flagButton, alignment: .center).withMargins(.init(
            top: 0, left: 16, bottom: 0, right: 16))
        
    }    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
