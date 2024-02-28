//
//  ChatLogController.swift
//  Tinder
//
//  Created by Turan Çabuk on 26.02.2024.
//

import LBTATools
import UIKit


class ChatLogController: LBTAListController<MessageCell, Message>, UICollectionViewDelegateFlowLayout {
    
    fileprivate lazy var customNavBar = MatchNavBar(match: self.match)
    fileprivate let match: Match
    
    init(match: Match) {
        self.match = match
        super.init()
    }
    
    class CustomInputAccesorryView: UIView {
        
        let textView = UITextView()
        let sendButton = UIButton(title: "Send", titleColor: .black, font: .boldSystemFont(ofSize: 14), target: nil, action: nil)
        let placeHolderLabel = UILabel(text: "Enter Message", font: .systemFont(ofSize: 16), textColor: .lightGray)
        
        override var intrinsicContentSize: CGSize {
            return .zero
        }
        
        override init(frame: CGRect) {
            super.init(frame: frame)
            backgroundColor = .white
            setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: 8), color: .lightGray)
            autoresizingMask = .flexibleHeight
            
            textView.isScrollEnabled = false
            textView.font = .systemFont(ofSize: 16)
            
            NotificationCenter.default.addObserver(self, selector: #selector(handleTextChanged), name: UITextView.textDidChangeNotification, object: nil)
            hstack(textView,
                   sendButton.withSize(.init(width: 60, height: 60)), alignment: .center).withMargins(.init(top: 0, left: 16, bottom: 0, right: 16))
            
            addSubview(placeHolderLabel)
            placeHolderLabel.anchor(top: nil, leading: leadingAnchor, bottom: nil, trailing: sendButton.leadingAnchor, padding: .init(
                top: 0, left: 20, bottom: 0, right: 0))
            placeHolderLabel.centerYAnchor.constraint(equalTo: sendButton.centerYAnchor).isActive = true
        }
        @objc fileprivate func handleTextChanged() {
            placeHolderLabel.isHidden = textView.text.count != 0
        }
        deinit {
            NotificationCenter.default.removeObserver(self)
        }
        required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
        }
    }
    
    lazy var redView: UIView = {
        return CustomInputAccesorryView(frame: .init(x: 0, y: 0, width: view.frame.width, height: 50))
    }()
    
    override var inputAccessoryView: UIView? {
        get {
            return redView
        }
    }
    
    override var canBecomeFirstResponder: Bool {
        return true
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
        collectionView.keyboardDismissMode = .interactive
        
        
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
