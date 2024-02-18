//
//  CardView.swift
//  Tinder
//
//  Created by Turan Çabuk on 29.01.2024.
//

import UIKit
import SDWebImage

protocol CardViewDelegate {
    func didTapInfoButton(cardViewModel: CardViewModel)
    func didRemoveCard(cardView: CardView)
}
class CardView: UIView {
    
    var cardViewModel: CardViewModel! {
        didSet {
            let imageName = cardViewModel.imageNames.first ?? ""
            if let url = URL(string: imageName) {
                imageView.sd_setImage(with: url)
            }
            informationLabel.attributedText = cardViewModel.attributedString
            informationLabel.textAlignment = cardViewModel.textAlignment
            
            (0..<cardViewModel.imageNames.count).forEach { (_) in
                let barView = UIView()
                barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
                barView.layer.cornerRadius = 6
                barStackView.addArrangedSubview(barView)
            }
            barStackView.arrangedSubviews.first?.backgroundColor = .white
            setupImageIndexObserver()
        }
    }
    
    // encapsulation
    fileprivate let imageView = UIImageView()
    fileprivate let informationLabel = UILabel()
    fileprivate let gradientLayer = CAGradientLayer()
    fileprivate var barStackView = UIStackView()
    fileprivate var imageIndex = 0
    fileprivate var infoButton: UIButton = {
        let button = UIButton(type: .system)
        button.setImage(UIImage(named: "info_icon"), for: .normal)
        button.tintColor = .white
        button.widthAnchor.constraint(equalToConstant: 40).isActive = true
        button.heightAnchor.constraint(equalToConstant: 40).isActive = true
        button.addTarget(self, action: #selector(handleIndex), for: .touchUpInside)
        return button
    }()
    
    // Configurations
    fileprivate let threshold: CGFloat = 80
    var delegate: CardViewDelegate?  
    var nextCardView: CardView?
    
    override init(frame: CGRect) {
        super.init(frame: frame)

        
        addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(handlePan)))
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleTap)))
        
        setupLayout()
    }
    // MARK: Layout Confs.
    fileprivate func setupLayout() {
        layer.cornerRadius = 10
        clipsToBounds = true
        
        imageView.contentMode = .scaleAspectFill
        addSubview(imageView)
        imageView.fillSuperview()
        
        setupBarStackView()
        setGradientLayer()
        
        addSubview(informationLabel)
        informationLabel.anchor(top: nil, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(
            top: 0, left: 16, bottom: 16, right: 16))
        
        informationLabel.textColor = .white
        informationLabel.numberOfLines = 0
        
        addSubview(infoButton)
        infoButton.anchor(
            top: nil, leading: nil, bottom: bottomAnchor, trailing: trailingAnchor, padding: .init(
                top: 0, left: 0, bottom: 5, right: 5))
    }
    fileprivate func setGradientLayer() {
        
        gradientLayer.colors = [UIColor.clear.cgColor, UIColor.black.cgColor]
        gradientLayer.locations = [0.5, 1.5]
        layer.addSublayer(gradientLayer)
    
    }
    override func layoutSubviews() {
        
        gradientLayer.frame = self.frame
    }
    fileprivate func setupBarStackView() {
        
        addSubview(barStackView)
        barStackView.anchor(top: topAnchor, leading: leadingAnchor, bottom: nil, trailing: trailingAnchor, padding: .init(
            top: 8, left: 8, bottom: 0, right: 8), size: .init(
                width: 0, height: 4))
        
        barStackView.spacing = 4
        barStackView.distribution = .fillEqually
    }
    // MARK: Gesture Reconizer Confs.
    @objc fileprivate func handlePan(gesture: UIPanGestureRecognizer) {
        switch gesture.state {
        case .began:
            superview?.subviews.forEach({ (subview) in
                subview.layer.removeAllAnimations()
            })
        case .changed:
            handleChanged(gesture)
        case .ended:
            handleEnded(gesture: gesture)
        default:
            ()
        }
    }
    @objc fileprivate func handleTap(gesture: UITapGestureRecognizer) {
        let tapLocation = gesture.location(in: nil)
        let advanceNextPhoto = tapLocation.x > frame.width / 2
        
        if advanceNextPhoto {
            cardViewModel.advanceToNextPhoto()
        }else{
            cardViewModel.advanceToPreviousPhoto()
        }
    }
    fileprivate func handleChanged(_ gesture: UIPanGestureRecognizer) {
        let translation = gesture.translation(in: nil)
        let degrees: CGFloat = translation.x / 20
        let angle = degrees * .pi / 180
        
        let rotationalTransformation = CGAffineTransform(rotationAngle: angle)
        self.transform = rotationalTransformation.translatedBy(x: translation.x, y: translation.y)
    }
    fileprivate func handleEnded(gesture: UIPanGestureRecognizer) {
        let translationDirection: CGFloat = gesture.translation(in: nil).x > 0 ? 1 : -1
        let shouldDismissCard = abs(gesture.translation(in: nil).x) > threshold
        
        if shouldDismissCard {
            // Accesing the HomeController selectors.
            guard let homeController = delegate as? HomeController else {return}
            
            if translationDirection == 1 {
                homeController.handleLike()
            }else{
                homeController.handleDislike()
            }
        }else{
            UIView.animate(withDuration: 1, delay: 0, usingSpringWithDamping: 0.6, initialSpringVelocity: 0.1, options: .curveEaseOut, animations: {
                self.transform = .identity})
        }
    }
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self] (idx,imageUrl) in
 
            if let url = URL(string: imageUrl ?? "") {
                self?.imageView.sd_setImage(with: url, placeholderImage: UIImage(named: "questionMark"), options: .continueInBackground)
            }
            self?.barStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = UIColor(white: 0, alpha: 0.1)
            })
            self?.barStackView.arrangedSubviews[idx].backgroundColor = .white
        } 
    }
    @objc fileprivate func handleIndex() {
        delegate?.didTapInfoButton(cardViewModel: cardViewModel)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
