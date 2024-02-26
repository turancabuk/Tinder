//
//  ChatLogController.swift
//  Tinder
//
//  Created by Turan Çabuk on 26.02.2024.
//

import LBTATools
import UIKit

struct Message {
    let text: String
}

class MessageCell: LBTAListCell<Message> {
    
    override var item: Message! {
        didSet {
            backgroundColor = .red
        }
    }
}
class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MatchNavBar(match: self.match)
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        items = [
            .init(text: "Hello From logs"),
            .init(text: "Hello From logs"),
            .init(text: "Hello From logs")
        ]
        
        setupLayout()
        customNavBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        
    }
    fileprivate func setupLayout() {
        view.addSubview(customNavBar)
        customNavBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(
                width: 0, height: 150))
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return .init(width: view.frame.width, height: 100)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return .init(top: 160, left: 0, bottom: 0, right: 0)
    }
    @objc fileprivate func handleBackButton() {
        
        navigationController?.popViewController(animated: true)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
