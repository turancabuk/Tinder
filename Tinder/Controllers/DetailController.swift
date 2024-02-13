//
//  DetailController.swift
//  Tinder
//
//  Created by Turan Çabuk on 13.02.2024.
//

import UIKit

class DetailController: UIViewController {

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
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.heightAnchor.constraint(equalToConstant: 500).isActive = true
        image.backgroundColor = .white
        return image
    }()
    
    fileprivate var informationLabel = UILabel()
    fileprivate var barStackView = UIStackView()
    let dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"))
    let superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"))
    let likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"))

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        view.backgroundColor = .white
        setupLayout()
    }
    fileprivate func setupLayout() {
        
        view.addSubview(imageView)
        imageView.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor)
        
        view.addSubview(informationLabel)
        informationLabel.backgroundColor = .white
        informationLabel.heightAnchor.constraint(equalToConstant: 100).isActive = true
        informationLabel.widthAnchor.constraint(equalToConstant: 300).isActive = true
        
        informationLabel.anchor(
            top: imageView.bottomAnchor, leading: view.leadingAnchor, bottom: nil, trailing: nil, padding: .init(
                top: 16, left: 16, bottom: 0, right: 0))
        
        let bottomStackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        view.addSubview(bottomStackView)
        bottomStackView.heightAnchor.constraint(equalToConstant: 100).isActive = true
        bottomStackView.distribution = .fillEqually
        bottomStackView.anchor(
            top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(
                top: 0, left: 50, bottom: 16, right: 50))
    }
    static func createButton(image: UIImage) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        return button
    }
    fileprivate func setupImageIndexObserver() {
        cardViewModel.imageIndexObserver = { [weak self] (idx,imageUrl) in
 
            if let url = URL(string: imageUrl ?? "") {
                self?.imageView.sd_setImage(with: url)
            }
            self?.barStackView.arrangedSubviews.forEach({ (v) in
                v.backgroundColor = UIColor(white: 0, alpha: 0.1)
            })
            self?.barStackView.arrangedSubviews[idx].backgroundColor = .white
        }
    }
}
