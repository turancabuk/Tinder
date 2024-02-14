//
//  DetailController.swift
//  Tinder
//
//  Created by Turan Çabuk on 13.02.2024.
//

import UIKit
import SDWebImage

class DetailController: UIViewController, UIScrollViewDelegate {

    var cardViewModel: CardViewModel! {
        didSet {
            informationLabel.attributedText = cardViewModel.attributedString
            guard let firstImageUrl = cardViewModel.imageNames.first, let url = URL(string: firstImageUrl) else {return}
            imageView.sd_setImage(with: url)
        }
    }
    
    lazy var scrollView: UIScrollView = {
        let sv = UIScrollView()
        sv.alwaysBounceVertical = true
        sv.contentInsetAdjustmentBehavior = .never
        sv.delegate = self
        return sv
    }()
    
    let imageView: UIImageView = {
        let image = UIImageView()
        image.heightAnchor.constraint(equalToConstant: 500).isActive = true
        image.backgroundColor = .white
        image.contentMode = .scaleAspectFill
        image.clipsToBounds = true
        return image
    }()
    
    let informationLabel: UILabel = {
        let label = UILabel()
        label.heightAnchor.constraint(equalToConstant: 100).isActive = true
        label.widthAnchor.constraint(equalToConstant: 300).isActive = true
        label.text = "User Name 30\nDoctor\n Some Bio text down below"
        label.numberOfLines = 0
        return label
    }()
    
    var dismissButton: UIButton = {
        var button = UIButton(type: .system)
        button.widthAnchor.constraint(equalToConstant: 60).isActive = true
        button.heightAnchor.constraint(equalToConstant: 60).isActive = true
        button.setImage(UIImage(named: "dismiss")?.withRenderingMode(.alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(handleDismissButton), for: .touchUpInside)
        return button
    }()
    
    var bottomStackView: UIStackView = {
        let sv = UIStackView()
        sv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return sv
    }()
    
    fileprivate var barStackView = UIStackView()
    lazy var dislikeButton = createButton(image: #imageLiteral(resourceName: "dismiss_circle"), selector: #selector(handleDisLike))
    lazy var superLikeButton = createButton(image: #imageLiteral(resourceName: "super_like_circle"), selector: #selector(handleSuperLike))
    lazy var likeButton = createButton(image: #imageLiteral(resourceName: "like_circle"), selector: #selector(handleLike))

    
    override func viewDidLoad() {
        super.viewDidLoad()
         
        setupLayout()
        setupBlurEffect()
    }
    fileprivate func setupLayout() {

        view.backgroundColor = .white
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        
        scrollView.addSubview(imageView)
        imageView.frame = CGRect(
            x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(dismissButton)
        dismissButton.anchor(
            top: imageView.bottomAnchor, leading: nil, bottom: nil, trailing: view.trailingAnchor, padding: .init(
                top: -28, left: 0, bottom: 0, right: 16))
        
        scrollView.addSubview(informationLabel)
        informationLabel.anchor(
            top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(
                top: 16, left: 16, bottom: 0, right: 0))
        
        bottomStackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        view.addSubview(bottomStackView)
        bottomStackView.distribution = .fillEqually
        bottomStackView.anchor(
            top: nil, leading: view.leadingAnchor, bottom: view.bottomAnchor, trailing: view.trailingAnchor, padding: .init(
                top: 0, left: 50, bottom: 32, right: 50))
    }
    fileprivate func setupBlurEffect() {
        let effect = UIBlurEffect(style: .regular)
        let visualEffectView = UIVisualEffectView(effect: effect)
        
        view.addSubview(visualEffectView)
        visualEffectView.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    fileprivate func createButton(image: UIImage, selector: Selector) -> UIButton {
        let button = UIButton(type: .system)
        button.setImage(image.withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFill
        button.addTarget(self, action: selector, for: .touchUpInside)
        return button
    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // for Stretchy Header Frame
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        imageView.frame = CGRect(
            x: min(0, -changeY), y: min(0, -changeY), width: width, height: width)
    }
    @objc fileprivate func handleDismissButton() {
        self.dismiss(animated: true)
    }
    @objc  func handleDisLike() {
        print("***hello***")
    }
    @objc  func handleSuperLike() {
        print("***hello1***")
    }
    @objc  func handleLike() {
        print("***hello2***")
    }
}
