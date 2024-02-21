//
//  MatchView.swift
//  Tinder
//
//  Created by Turan Çabuk on 19.02.2024.
//

import UIKit
import Firebase

class MatchView: UIView {
        
    var cardUID: String! {
        didSet {
            Firestore.firestore().collection("users").document(cardUID).getDocument { (snapShot, err) in
                if let err = err {
                    print("Error: ", err)
                    return
                }
                guard let dictionary = snapShot?.data() else {return}
                let user = User(dictionary: dictionary)
                guard let url = URL(string: user.imageUrl1 ?? "") else {return}
                self.currentUserImageView.sd_setImage(with: url)
                self.cardUserImageView.alpha = 1
            }
        }
    }
    var currentUser: User! {
        didSet {
            guard let URL = URL(string: currentUser.imageUrl1 ?? "") else {return}
            self.cardUserImageView.sd_setImage(with: URL)
        }
    }
    fileprivate let matchView: UIImageView = {
        let imageView = UIImageView(image: #imageLiteral(resourceName: "match"))
        return imageView
    }()
    fileprivate let matchLabel: UILabel = {
        let label = UILabel()
        label.text = "You and X have liked each other"
        label.font = .systemFont(ofSize: 18)
        label.textColor = .white
        label.numberOfLines = 0
        return label
    }()
    fileprivate let currentUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        return imageView
    }()
    fileprivate let cardUserImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.borderWidth = 2
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.alpha = 0
        return imageView
    }()
    fileprivate let messageButton: UIButton = {
        let button = GradientButton(type: .system)
        button.setTitle("SEND MESSAGE", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    fileprivate let swipingButton: UIButton = {
        let button = GradientButtonBorder(type: .system)
        button.setTitle("Keep Swiping", for: .normal)
        button.setTitleColor(.white, for: .normal)
        return button
    }()
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        setupBlurEffect()
        setupLayout()
        setupAnimations()

    }
    fileprivate func setupLayout() {
        addSubview(matchView)
        addSubview(matchLabel)
        addSubview(currentUserImageView)
        addSubview(cardUserImageView)
        addSubview(messageButton)
        addSubview(swipingButton)

        matchView.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(
                top: 170, left: 16, bottom: 0, right: 16), size: .init(
                    width: 100, height: 100))
        
        matchLabel.textAlignment = .center
        matchLabel.anchor(
            top: matchView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(
                top: 16, left: 0, bottom: 0, right: 0), size: .init(
                    width: 40, height: 40))
        
        currentUserImageView.anchor(
            top: nil, leading: nil, bottom: nil, trailing: centerXAnchor, padding: .init(
                top: 0, left: 0, bottom: 0, right: 16), size: .init(
                    width: 140, height: 140))
        currentUserImageView.layer.cornerRadius = 140 / 2
        currentUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        cardUserImageView.anchor(
            top: nil, leading: centerXAnchor, bottom: nil, trailing: nil, padding: .init(
                top: 0, left: 16, bottom: 0, right: 0), size: .init(
                width: 140, height: 140))
        cardUserImageView.layer.cornerRadius = 140 / 2
        cardUserImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        
        messageButton.anchor(
            top: currentUserImageView.bottomAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(
                top: 32, left: 48, bottom: 0, right: 48), size: .init(
                    width: 0, height: 60))

        swipingButton.anchor(
            top: messageButton.bottomAnchor, leading: messageButton.leadingAnchor, bottom: nil, trailing: messageButton.trailingAnchor, padding: .init(
                top: 16, left: 0, bottom: 0, right: 0), size: .init(
                    width: 0, height: 60))
    }
    fileprivate func setupAnimations() {

        // ImageViews Moving
        currentUserImageView.transform = CGAffineTransform(rotationAngle: -(30 * CGFloat.pi / 180)).concatenating(CGAffineTransform(translationX: 200, y: 0))
        cardUserImageView.transform = CGAffineTransform(rotationAngle: (30 * CGFloat.pi / 180)).concatenating(CGAffineTransform(translationX: -200, y: 0))
        
        // Buttons Moving
        messageButton.transform = CGAffineTransform(translationX: -500, y: 0)
        swipingButton.transform = CGAffineTransform(translationX: 500, y: 0)
                
        UIView.animateKeyframes(withDuration: 1.3, delay: 0, options: .calculationModeCubic, animations: {
            // ImageViews Animation 1
            UIView.addKeyframe(withRelativeStartTime: 0, relativeDuration: 0.45, animations: {
                self.currentUserImageView.transform = CGAffineTransform(rotationAngle: -(30 * CGFloat.pi / 180))
                self.cardUserImageView.transform = CGAffineTransform(rotationAngle: 30 * CGFloat.pi / 180)
            })
            
            // ImageViews back to original positions
            UIView.addKeyframe(withRelativeStartTime: 0.6, relativeDuration: 0.4, animations: {
                self.currentUserImageView.transform = .identity
                self.cardUserImageView.transform = .identity
            })
            
            
        }) { (_) in
            
        }
        // Buttons back to original positions
        UIView.animate(withDuration: 0.75, delay: 0.6 * 1.3, usingSpringWithDamping: 0.5, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
            self.messageButton.transform = .identity
            self.swipingButton.transform = .identity
        })
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
