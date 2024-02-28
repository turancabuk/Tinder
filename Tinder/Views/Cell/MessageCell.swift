//
//  MessageCell.swift
//  Tinder
//
//  Created by Turan Çabuk on 28.02.2024.
//

import LBTATools
import UIKit

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
