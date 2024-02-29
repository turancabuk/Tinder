//
//  MessageController.swift
//  Tinder
//
//  Created by Turan Çabuk on 21.02.2024.
//

import UIKit
import LBTATools
import Firebase


class RecentMessageCell: LBTAListCell<UIColor> {
    
    let userProfileImageView = UIImageView(image: #imageLiteral(resourceName: "fred"), contentMode: .scaleAspectFill)
    let userNameLabel = UILabel(text: "USER NAME", font: .boldSystemFont(ofSize: 18))
    let messageTextLabel = UILabel(text: "2. Sektörde sarı bayraklar var ve Sebastian Vettel bariyerlerde", font: .systemFont(ofSize: 16), numberOfLines: 2)
    
    override var item: UIColor!{
        didSet{
//            backgroundColor = item
        }
    }
    override func setupViews() {
        
        userProfileImageView.layer.cornerRadius = 90 / 2
        
        hstack(userProfileImageView.withWidth(90).withHeight(90), stack(userNameLabel, messageTextLabel, spacing: 4), spacing: 20, alignment: .center).padLeft(20).padRight(10)
        
        addSeparatorView(leadingAnchor: userNameLabel.leadingAnchor)
    }
}
class MessageController: LBTAListHeaderController<RecentMessageCell, UIColor, MatchesHeader>, UICollectionViewDelegateFlowLayout {
    
    let customNavBar = MessageCustomNavBar()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let layout = collectionViewLayout as? UICollectionViewFlowLayout {
            layout.scrollDirection = .vertical
        }
        items = [.purple, .orange, .systemPink, .red]
        
        setupLayout()
        customNavBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        
    }
    fileprivate func setupLayout() {
        
        view.addSubview(customNavBar)
        customNavBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(
                width: 0, height: 150))
        navigationController?.navigationBar.isHidden = true
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
        
    }
    override func setupHeader(_ header: MatchesHeader) {
        header.matchesHorizontalController.rootMatchesController = self
    }
    
    func didSelectMatchFromHeader(match: Match) {
        let chatLogController = ChatLogController(match: match)
        navigationController?.pushViewController(chatLogController, animated: true)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        return .init(width: view.frame.width, height: 410)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(
            top: 0, left: 12, bottom: 0, right: 12)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 120)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    @objc fileprivate func handleBackButton() {
        dismiss(animated: true)
    }
}
