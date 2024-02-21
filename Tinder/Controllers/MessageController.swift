//
//  MessageController.swift
//  Tinder
//
//  Created by Turan Çabuk on 21.02.2024.
//

import UIKit
import LBTATools

class MatchCell: LBTAListCell<UIColor> {
    
    let profilImageView = UIImageView(image: #imageLiteral(resourceName: "fred"), contentMode: .scaleAspectFit)
    let userNameLabel = UILabel(text: "User Name Here", font: .systemFont(ofSize: 14, weight: .semibold))
    
    override var item: UIColor! {
        didSet {
            backgroundColor = item
        }
    }
    
    override func setupViews() {
        
        profilImageView.clipsToBounds = true
        profilImageView.constrainWidth(80)
        profilImageView.constrainHeight(85)
        profilImageView.layer.cornerRadius = 80 / 2
        stack(stack(profilImageView, alignment: .center), userNameLabel)
    }
}

class MessageController: LBTAListController<MatchCell, UIColor>, UICollectionViewDelegateFlowLayout {
    
    let customNavBar = MessageCustomNavBar()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.backgroundColor = .white
        
        setupLayout()
        customNavBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        items = [.clear, .clear, .clear, .clear, .clear]
        
    }
    fileprivate func setupLayout() {
        view.addSubview(customNavBar)

        customNavBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(
                width: 0, height: 150))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(
            top: 160, left: 12, bottom: 0, right: 12)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: 120, height: 120)
    }
    @objc fileprivate func handleBackButton() {
        navigationController?.popViewController(animated: true)
    }
}
