//
//  CustomInputAccessoryView.swift
//  Tinder
//
//  Created by Turan Çabuk on 28.02.2024.
//

import UIKit
import LBTATools

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
        setupShadow(opacity: 0.1, radius: 8, offset: .init(width: 0, height: -8), color: .lightGray)
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
