//
//  MatchView.swift
//  Tinder
//
//  Created by Turan Çabuk on 19.02.2024.
//

import UIKit

class MatchView: UIView {
    
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "fred"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    fileprivate let cardUserImageView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "kelly3"))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurEffect()
        setupLayout()

    }
    fileprivate func setupLayout() {
        addSubview(currentUserImageView)
        currentUserImageView.anchor(
            top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(
                top: 0, left: 0, bottom: 0, right: 16), size: .init(
                    width: 140, height: 140))
        currentUserImageView.layer.cornerRadius = 140 / 2
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        addSubview(cardUserImageView)
        cardUserImageView.anchor(
            top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(
                top: 0, left: 16, bottom: 0, right: 0), size: .init(
                width: 140, height: 140))
        cardUserImageView.layer.cornerRadius = 140 / 2
        cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
    }
    var visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))

    fileprivate func setupBlurEffect() {
        visualEffectView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
        addSubview(self.visualEffectView)
        visualEffectView.fillSuperview()
        self.visualEffectView.alpha = 0
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut, animations: {
            self.visualEffectView.alpha = 1
        }) {(_) in
            
        }
    }
    @objc fileprivate func handleDismiss() {
        UIView.animate(withDuration: 0.5, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1,options: .curveEaseOut, animations: {
            self.alpha = 0
        }) {(_) in
            self.removeFromSuperview()
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
