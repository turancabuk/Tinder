//
//  CustomTextfield.swift
//  Tinder
//
//  Created by Turan Çabuk on 31.01.2024.
//

import UIKit

class CustomTextField: UITextField {
    
    let pading: Int
    
    init(pading: Int) {
        self.pading = pading
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func textRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    override func editingRect(forBounds bounds: CGRect) -> CGRect {
        return bounds.insetBy(dx: 16, dy: 0)
    }
    override var intrinsicContentSize: CGSize {
        return .init(width: 0, height: 40)
    }
    func setup() {
        backgroundColor = .white
        textAlignment = .center
        layer.cornerRadius = 16
    }
}
