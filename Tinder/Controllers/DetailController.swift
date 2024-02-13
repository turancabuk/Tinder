//
//  DetailController.swift
//  Tinder
//
//  Created by Turan Çabuk on 13.02.2024.
//

import UIKit

class DetailController: UIViewController, UIScrollViewDelegate {

//    var cardViewModel: CardViewModel! {
//        didSet {
//            let imageName = cardViewModel.imageNames.first ?? ""
//            if let url = URL(string: imageName) {
//                imageView.sd_setImage(with: url)
//            }
//            informationLabel.attributedText = cardViewModel.attributedString
//            informationLabel.textAlignment = cardViewModel.textAlignment
//            
//            (0..<cardViewModel.imageNames.count).forEach { (_) in
//                let barView = UIView()
//                barView.backgroundColor = UIColor(white: 0, alpha: 0.1)
//                barView.layer.cornerRadius = 6
//                barStackView.addArrangedSubview(barView)
//            }
//            barStackView.arrangedSubviews.first?.backgroundColor = .white
//            setupImageIndexObserver()
//        }
//    }
    
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
        image.clipsToBounds = true
        image.image = UIImage(named: "fred")
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
    
    var bottomStackView: UIStackView = {
        let sv = UIStackView()
        sv.heightAnchor.constraint(equalToConstant: 100).isActive = true
        return sv
    }()
    
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
        
        view.addSubview(scrollView)
        scrollView.fillSuperview()
        
        scrollView.addSubview(imageView)
        imageView.frame = CGRect(
            x: 0, y: 0, width: view.frame.width, height: view.frame.width)
        
        scrollView.addSubview(informationLabel)
        informationLabel.anchor(
            top: imageView.bottomAnchor, leading: scrollView.leadingAnchor, bottom: nil, trailing: scrollView.trailingAnchor, padding: .init(
                top: 16, left: 16, bottom: 0, right: 0))
        
        bottomStackView = UIStackView(arrangedSubviews: [dislikeButton, superLikeButton, likeButton])
        view.addSubview(bottomStackView)
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
//    fileprivate func setupImageIndexObserver() {
//        cardViewModel.imageIndexObserver = { [weak self] (idx,imageUrl) in
// 
//            if let url = URL(string: imageUrl ?? "") {
//                self?.imageView.sd_setImage(with: url)
//            }
//            self?.barStackView.arrangedSubviews.forEach({ (v) in
//                v.backgroundColor = UIColor(white: 0, alpha: 0.1)
//            })
//            self?.barStackView.arrangedSubviews[idx].backgroundColor = .white
//        }
//    }
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // for Stretchy Header Frame
        let changeY = -scrollView.contentOffset.y
        var width = view.frame.width + changeY * 2
        width = max(view.frame.width, width)
        imageView.frame = CGRect(
            x: min(0, -changeY), y: min(0, -changeY), width: width, height: width)
    }
}
