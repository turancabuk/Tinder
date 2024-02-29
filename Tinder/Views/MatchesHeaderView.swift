//
//  MatchesHeaderView.swift
//  Tinder
//
//  Created by Turan Çabuk on 29.02.2024.
//

import UIKit
import LBTATools

class MatchesHeader: UICollectionReusableView {
    
    let newMatchesLabel = UILabel(text: "New Matches", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9860271811, green: 0.3476872146, blue: 0.4476813674, alpha: 1))
    let matchesHorizontalController = MatchesHorizontalController()
    let messagesLabel = UILabel(text: "Messages", font: .boldSystemFont(ofSize: 18), textColor: #colorLiteral(red: 0.9860271811, green: 0.3476872146, blue: 0.4476813674, alpha: 1))
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        stack(stack(newMatchesLabel).padLeft(20), matchesHorizontalController.view, stack(messagesLabel).padLeft(20),
              spacing: 10).withMargins(.init(
            top: 160, left: 0, bottom: 20, right: 0))
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
