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
    let isFromCurrentUser: Bool
}

class MessageCell: LBTAListCell<Message> {
    
    let textView: UITextView = {
        let tv = UITextView()
        tv.backgroundColor = .clear
        tv.font = .systemFont(ofSize: 20)
        tv.isScrollEnabled = false
        tv.isEditable = false
        return tv
    }()
    
    let bubbleContainer = UIView(backgroundColor: #colorLiteral(red: 0.8980392218, green: 0.8980391622, blue: 0.8980392218, alpha: 1))
    var anchoredConstraints: AnchoredConstraints!
    
    override var item: Message! {
        didSet {
            textView.text = item.text
            
            if item.isFromCurrentUser {
                anchoredConstraints.trailing?.isActive = true
                anchoredConstraints.leading?.isActive = false
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.1625309587, green: 0.751971662, blue: 0.9782939553, alpha: 1)
                textView.textColor = .white
            }else{
                anchoredConstraints.trailing?.isActive = false
                anchoredConstraints.leading?.isActive = true
                bubbleContainer.backgroundColor = #colorLiteral(red: 0.8980392218, green: 0.8980391622, blue: 0.8980392218, alpha: 1)
                textView.textColor = .black
            }
        }
    }
    override func setupViews() {
        super.setupViews()
         
        addSubview(bubbleContainer)
        bubbleContainer.layer.cornerRadius = 12
        
        anchoredConstraints = bubbleContainer.anchor(
            top: topAnchor, leading: leadingAnchor, bottom: bottomAnchor, trailing: trailingAnchor)
        anchoredConstraints.leading?.constant = 20
        anchoredConstraints.trailing?.isActive = false
        anchoredConstraints.trailing?.constant = -20
        bubbleContainer.widthAnchor.constraint(lessThanOrEqualToConstant: 250).isActive = true
        
        
        bubbleContainer.addSubview(textView)
        textView.fillSuperview(padding: .init(top: 4, left: 12, bottom: 4, right: 12))
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
            .init(text: "2. sektörde sarı bayraklar var ve Sebastian Vettel Bariyerlerde! 2. sektörde sarı bayraklar var ve Sebastian Vettel Bariyerlerde! 2. sektörde sarı bayraklar var ve Sebastian Vettel Bariyerlerde! 2. sektörde sarı bayraklar var ve Sebastian Vettel Bariyerlerde! 2. sektörde sarı bayraklar var ve Sebastian Vettel Bariyerlerde!", isFromCurrentUser: true),
            .init(text: "Sebastian Vettel kendi evinde bariyerlerde", isFromCurrentUser: false),
            .init(text: "Direksiyonu yumrukluyor Vettel..", isFromCurrentUser: true),
            .init(text: "Vettel..", isFromCurrentUser: false),
            .init(text: "2. sektörde sarı bayraklar var ve Sebastian Vettel Bariyerlerde! 2. sektörde sarı bayraklar var ve Sebastian Vettel Bariyerlerde! 2. sektörde sarı bayraklar var ve Sebastian Vettel Bariyerlerde! 2. sektörde sarı bayraklar var ve Sebastian Vettel Bariyerlerde! 2. sektörde sarı bayraklar var ve Sebastian Vettel Bariyerlerde!", isFromCurrentUser: false),

        ]
        
        setupLayout()
        customNavBar.backButton.addTarget(self, action: #selector(handleBackButton), for: .touchUpInside)
        
        
    }
    fileprivate func setupLayout() {
        view.addSubview(customNavBar)
        customNavBar.anchor(
            top: view.safeAreaLayoutGuide.topAnchor, leading: view.leadingAnchor, bottom: nil, trailing: view.trailingAnchor, size: .init(
                width: 0, height: 100))
        
        let statusBarCover = UIView(backgroundColor: .white)
        view.addSubview(statusBarCover)
        statusBarCover.anchor(
            top: view.topAnchor, leading: view.leadingAnchor, bottom: view.safeAreaLayoutGuide.topAnchor, trailing: view.trailingAnchor)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
      
        // Estimated Size for dynamic Cells
        let estimatedSizeCell = MessageCell(frame: .init(
            x: 0, y: 0, width: view.frame.width, height: 1000))
        estimatedSizeCell.item = self.items[indexPath.item]
        estimatedSizeCell.layoutIfNeeded()
        
        let estimatedSize = estimatedSizeCell.systemLayoutSizeFitting(.init(width: view.frame.width, height: 1000))
        return .init(width: view.frame.width, height: estimatedSize.height)
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
