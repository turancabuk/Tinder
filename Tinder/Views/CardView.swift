//
//  CardView.swift
//  Tinder
//
//  Created by Turan Çabuk on 29.01.2024.
//

import UIKit

class CardView: UIView {
    
    let imageView = UIImageView()
    let threshould: CGFloat = 100
    
    let nameLabel = UILabel()
    let ageLabel = UILabel()
    let professionLabel = UILabel()
    var informationStackView = UIStackView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        layer.cornerRadius = 10
        clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        
        addSubview(imageView)
        imageView.fillSuperview()
        
        [nameLabel, ageLabel, professionLabel].forEach { lbl in
            lbl.textColor = .white
            lbl.font = UIFont.systemFont(ofSize: 18, weight: .heavy)
        }
        nameLabel.font = .systemFont(ofSize: 26, weight: .heavy)
        
        informationStackView = VerticalStackView(arrangedSubviews: [
        UIStackView(arrangedSubviews: [nameLabel, ageLabel]),
        professionLabel
        ])
        
        addSubview(informationStackView)
        informationStackView.anchor(
            top: nil, leading: self.leadingAnchor, bottom: self.bottomAnchor, trailing: trailingAnchor, padding: .init(
            top: 0, left: 10, bottom: 20, right: 0))

        

        
        let panGesture = UIPanGestureRecognizer(target: self, action: #selector(handlePan))
        addGestureRecognizer(panGesture)
    }
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        
        switch gesture.state {
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture)
        default:
            ()
        }
    }
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        // rotation
        // some not that scary math here to convert radians to degrees
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    
    fileprivate func handleEnded(_ gesture: UIPanGestureRecognizer) {
        
        let translationalDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshould
        
        UIView.animate(withDuration: 0.75, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
           
            if shouldDismissCard {
                self.frame = CGRect(x: 1000 * translationalDirection, y: 0, width: self.frame.width, height: self.frame.height)
            }else{
                self.transform = .identity
            }
        }) { (_) in
            self.transform = .identity
            if shouldDismissCard {
                self.removeFromSuperview()
            }
        }
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
