//
//  GradientButton.swift
//  Tinder
//
//  Created by Turan Çabuk on 20.02.2024.
//

import UIKit

class GradientButton: UIButton {
    
    override func draw(_ rect: CGRect) {
        super.draw(rect)
        
        let gradientLayer = CAGradientLayer()
        let leftColor = #colorLiteral(red: 0.8924006224, green: 0.117617093, blue: 0.4611734748, alpha: 1)
        let rightColor = #colorLiteral(red: 0.9815869927, green: 0.3566627502, blue: 0.3759607673, alpha: 1)
        gradientLayer.colors = [leftColor.cgColor, rightColor.cgColor]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 0.5, y: 1.0)

        self.layer.insertSublayer(gradientLayer, at: 0)
        layer.cornerRadius = rect.height / 2
        clipsToBounds = true
        
        gradientLayer.frame = rect
    }
}
