//
//  TopNavigationStackView.swift
//  Tinder
//
//  Created by Turan Çabuk on 28.01.2024.
//

import UIKit

class TopNavigationStackView: UIStackView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        let subviews = [#imageLiteral(resourceName: "top_left_profile"), #imageLiteral(resourceName: "app_icon"), #imageLiteral(resourceName: "top_right_messages")].map { (img) -> UIView in
            let button = UIButton(type: .system)
            button.setImage(img.withRenderingMode(.alwaysOriginal), for: .normal)
            return button
        }
        
        subviews.forEach { (view) in
            addArrangedSubview(view)
        }
        distribution = .fillEqually
        heightAnchor.constraint(equalToConstant: 70).isActive = true
        
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
