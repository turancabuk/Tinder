//
//  HomeController.swift
//  Tinder
//
//  Created by Turan Çabuk on 27.01.2024.
//

import UIKit

class HomeController: UIViewController {
    
    let topStackView = TopNavigationStackView()
    let carDeckView = UIView()
    let buttonsStackView = HomeBottomControlsStackView()
    let cardViewModels = ([
        Advertiser(title: "Baby Tracker", brandName: "Little Steps Development", posterPhotoName: "Settings View"),
        User(name: "Kelly", age: 23, profession: "Music DJ", imageNames: ["kelly1", "kelly2", "kelly3"]),
        User(name: "Jane", age: 18, profession: "Teacher", imageNames: ["jane1", "jane2", "jane3"])
    ] as [ProducesCardViewModel]).map { (producer) -> CardViewModel in
        return producer.toCardViewModel()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupLayout(topStackView, carDeckView, buttonsStackView)
        setupDummyCards()
        
    }
    fileprivate func setupDummyCards() {
        cardViewModels.forEach { (cardVM) in
            let cardView = CardView(frame: .zero)
            cardView.cardViewModel = cardVM
            carDeckView.addSubview(cardView)
            cardView.fillSuperview()
        }
    }
    fileprivate func setupLayout(_ topStackView: TopNavigationStackView, _ blueView: UIView, _ buttonsStackView: HomeBottomControlsStackView) {
        let overAllStackView = UIStackView(arrangedSubviews: [
            topStackView, blueView, buttonsStackView
        ])
        overAllStackView.axis = .vertical
        view.addSubview(overAllStackView)
        overAllStackView.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.bottomAnchor, trailing: view.trailingAnchor)
        overAllStackView.isLayoutMarginsRelativeArrangement = true
        overAllStackView.layoutMargins = .init(top: 0, left: 12, bottom: 0, right: 12)
        
        overAllStackView.bringSubviewToFront(carDeckView)
    }
}

